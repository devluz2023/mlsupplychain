from datetime import datetime, timedelta
import hashlib
import os
import pandas as pd
from sqlalchemy import create_engine, text
from airflow import DAG
from airflow.operators.python import PythonOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

def pipeline_extracao_e_feast():
    print("Iniciando ETL de suprimentos a partir do MySQL Transacional...")
    
    # 1. Ligação ao MySQL Transacional (Origem OLTP)
    mysql_conn_str = os.getenv(
        "MYSQL_CONNECTION", 
        "mysql+pymysql://root:mysql_password@mysql_transacional:3306/controlplatform_db"
    )
    engine_mysql = create_engine(mysql_conn_str)
    
    query = """
        WITH fornecedores AS (
            SELECT entidade_nome AS fornecedor_nome
            FROM agendamentos
            WHERE tipo_agendamento = 'RECEBIMENTO_FORNECEDOR'
            UNION
            SELECT fornecedor_nome
            FROM insumos_recebidos
        ),
        estatisticas_agendamentos AS (
            SELECT
                entidade_nome AS fornecedor_nome,
                COUNT(*) AS total_agendamentos,
                SUM(status_agendamento = 'CANCELADO') AS total_cancelados
            FROM agendamentos
            WHERE tipo_agendamento = 'RECEBIMENTO_FORNECEDOR'
            GROUP BY entidade_nome
        ),
        estatisticas_atrasos AS (
            SELECT
                a.entidade_nome AS fornecedor_nome,
                AVG(GREATEST(DATEDIFF(e.data_entrega_realizada, e.data_entrega_prevista), 0))
                    AS media_dias_atraso
            FROM agendamentos AS a
            INNER JOIN entregas AS e ON e.agendamento_id = a.id
            WHERE a.tipo_agendamento = 'RECEBIMENTO_FORNECEDOR'
              AND e.data_entrega_realizada IS NOT NULL
              AND e.data_entrega_prevista IS NOT NULL
            GROUP BY a.entidade_nome
        ),
        estatisticas_qualidade AS (
            SELECT
                fornecedor_nome,
                SUM(status_inspecao = 'REPROVADO') AS total_insumos_reprovados
            FROM insumos_recebidos
            GROUP BY fornecedor_nome
        )
        SELECT
            f.fornecedor_nome,
            COALESCE(a.total_agendamentos, 0) AS total_agendamentos,
            COALESCE(a.total_cancelados, 0) AS total_cancelados,
            COALESCE(d.media_dias_atraso, 0.0) AS media_dias_atraso,
            COALESCE(q.total_insumos_reprovados, 0) AS total_insumos_reprovados
        FROM fornecedores AS f
        LEFT JOIN estatisticas_agendamentos AS a
            ON a.fornecedor_nome = f.fornecedor_nome
        LEFT JOIN estatisticas_atrasos AS d
            ON d.fornecedor_nome = f.fornecedor_nome
        LEFT JOIN estatisticas_qualidade AS q
            ON q.fornecedor_nome = f.fornecedor_nome
    """
    
    try:
        df = pd.read_sql(query, con=engine_mysql)
        print(f"Dados extraídos com sucesso do MySQL. Total de registos: {len(df)}")
    except Exception as e:
        print(f"Erro ao consultar o MySQL transacional: {e}")
        raise e

    if df.empty:
        raise ValueError(
            "Nenhum fornecedor encontrado em agendamentos ou insumos_recebidos."
        )

    def supplier_id(name):
        normalized_name = name.strip().casefold().encode("utf-8")
        return int.from_bytes(
            hashlib.sha256(normalized_name).digest()[:8], "big"
        ) & 0x7FFFFFFFFFFFFFFF

    df["fornecedor_id"] = df["fornecedor_nome"].map(supplier_id).astype("int64")
    if df["fornecedor_id"].duplicated().any():
        raise ValueError("Colisão ao gerar IDs determinísticos para fornecedores.")

    # Adicionar timestamp de evento para compatibilidade com o Feast (Point-in-Time)
    df["event_timestamp"] = pd.Timestamp.now(tz="UTC").tz_localize(None)

    print("--- A carregar dados para a Camada Analítica (PostgreSQL / DW) ---")
    
    # 2. Ligação ao PostgreSQL Analítico (Destino OLAP / DW)
    postgres_conn_str = os.getenv(
        "ANALYTICAL_DB_CONNECTION", 
        "postgresql+psycopg2://airflow:airflow_password@postgres:5432/control_platform"
    )
    engine_postgres = create_engine(postgres_conn_str)
    
    # Se a tabela não existir, o pandas cria-a automaticamente ('replace' recria se a estrutura mudar, 
    # ou pode usar 'append' se preferir acumular histórico)
    with engine_postgres.begin() as conn:
        df.to_sql(
            'dim_fornecedores', 
            con=conn, 
            if_exists='replace', 
            index=False
        )
        
        conn.execute(text(
            "CREATE INDEX IF NOT EXISTS idx_dim_fornecedores_id "
            "ON dim_fornecedores (fornecedor_id);"
        ))
    
    print("Tabela 'dim_fornecedores' verificada/criada e dados carregados com sucesso no PostgreSQL!")
    print("Processo de ETL concluído de ponta a ponta.")

with DAG(
    'etl_suprimentos_comportamento',
    default_args=default_args,
    description='Pipeline de ETL para análise de fornecedores com criação automática de tabela no DW',
    schedule_interval='@daily',
    start_date=datetime(2026, 1, 1),
    catchup=False,
) as dag:

    t_extracao = PythonOperator(
        task_id='executar_etl_suprimentos',
        python_callable=pipeline_extracao_e_feast,
    )

    t_extracao