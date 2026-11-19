import os
import sys
from pathlib import Path
import mlflow
import mlflow.pytorch
import torch
import torch.nn as nn
import torch.optim as optim
import pandas as pd
import numpy as np
from sqlalchemy import create_engine, text
from feast import FeatureStore
from mlflow.models.signature import ModelSignature
from mlflow.types.schema import Schema, TensorSpec

# 1. Configurar o MLflow
mlflow_tracking_uri = os.getenv("MLFLOW_TRACKING_URI", "http://localhost:5001")
mlflow.set_tracking_uri(mlflow_tracking_uri)
experiment_name = "autoencoder_fornecedores_experiment"
experiment = mlflow.get_experiment_by_name(experiment_name)
if (
    experiment is not None
    and experiment.artifact_location.startswith("/")
    and not Path(experiment.artifact_location).exists()
):
    experiment_name = f"{experiment_name}_artifact_proxy"
mlflow.set_experiment(experiment_name)

# Arquitetura do Autoencoder em PyTorch
class AutoencoderFornecedor(nn.Module):
    def __init__(self, input_dim):
        super(AutoencoderFornecedor, self).__init__()
        self.encoder = nn.Sequential(
            nn.Linear(input_dim, 4),
            nn.ReLU(),
            nn.Linear(4, 2)  # Espaço latente de 2 dimensões
        )
        self.decoder = nn.Sequential(
            nn.Linear(2, 4),
            nn.ReLU(),
            nn.Linear(4, input_dim)
        )

    def forward(self, x):
        return self.decoder(self.encoder(x))

def executar_pipeline():
    with mlflow.start_run(run_name="treinamento_autoencoder_fornecedores"):
        
        print("--- PASSO 1: Obter IDs de entidades dinamicamente do Data Warehouse (PostgreSQL) ---")
        postgres_conn_str = os.getenv(
            "ANALYTICAL_DB_CONNECTION", 
            "postgresql+psycopg2://airflow:airflow_password@localhost:5432/control_platform"
        )
        engine_dw = create_engine(postgres_conn_str)
        
        query_ids = "SELECT DISTINCT fornecedor_id FROM dim_fornecedores"
        entity_df = pd.read_sql(query_ids, con=engine_dw)
        
        if entity_df.empty:
            raise ValueError("A tabela dim_fornecedores no DW está vazia. O pipeline foi interrompido.")

        entity_df["event_timestamp"] = pd.Timestamp.now(tz="UTC").tz_localize(None)
        print(f"Entidades carregadas com sucesso do DW: {len(entity_df)} fornecedores.")

        print("--- PASSO 2: Extrair Features validadas da Feature Store (Feast) ---")
        default_repo_path = Path(__file__).resolve().parent.parent / "feature_repository"
        repo_path = Path(
            os.getenv("FEAST_REPO_PATH", str(default_repo_path))
        ).expanduser().resolve()
        if not repo_path.is_dir():
            raise FileNotFoundError(f"Feast repository not found: {repo_path}")
        repo_path = str(repo_path)
        if repo_path not in sys.path:
            sys.path.insert(0, repo_path)
        from suprimentos_features import fornecedor_entity, fornecedor_comportamento_fv

        store = FeatureStore(repo_path=repo_path)
        store.apply([fornecedor_entity, fornecedor_comportamento_fv])
        if not any(
            view.name == fornecedor_comportamento_fv.name
            for view in store.list_feature_views()
        ):
            raise RuntimeError(
                f"Feature view {fornecedor_comportamento_fv.name} was not registered "
                f"in Feast project {store.project}."
            )
        
        features = [
            "fornecedor_comportamento_fv:total_agendamentos",
            "fornecedor_comportamento_fv:total_cancelados",
            "fornecedor_comportamento_fv:media_dias_atraso",
            "fornecedor_comportamento_fv:total_insumos_reprovados"
        ]
        
        df_features = store.get_historical_features(
            entity_df=entity_df,
            features=features
        ).to_df()
        
        print(f"Features obtidas com sucesso do Feast. Total: {df_features.shape[0]} registos.")

        # Definir colunas de feições
        feature_cols = ['total_agendamentos', 'total_cancelados', 'media_dias_atraso', 'total_insumos_reprovados']

        print("--- PASSO 3: Pré-processamento e Normalização (Z-score) para PyTorch ---")
        X = df_features[feature_cols].values.astype(np.float32)
        if not np.isfinite(X).all():
            invalid_columns = [
                column
                for column, values in zip(feature_cols, X.T)
                if not np.isfinite(values).all()
            ]
            raise ValueError(
                f"Feature data contains non-finite values in: {invalid_columns}"
            )
        
        X_mean = X.mean(axis=0)
        X_std = X.std(axis=0) + 1e-8
        X_norm = (X - X_mean) / X_std
        tensor_x = torch.tensor(X_norm)

        mlflow.log_param("num_fornecedores", len(df_features))
        mlflow.log_param("epochs", 50)
        mlflow.log_param("input_dim", X.shape[1])

        print("--- PASSO 4: Treinar o Modelo Autoencoder ---")
        model = AutoencoderFornecedor(X.shape[1])
        criterion = nn.MSELoss()
        optimizer = optim.Adam(model.parameters(), lr=0.01)

        for epoch in range(50):
            optimizer.zero_grad()
            outputs = model(tensor_x)
            loss = criterion(outputs, tensor_x)
            loss.backward()
            optimizer.step()
            final_loss = loss.item()

        if not np.isfinite(final_loss):
            raise RuntimeError("Autoencoder training produced a non-finite loss.")
        print(f"Treino concluído com sucesso. Loss final: {final_loss:.6f}")
        mlflow.log_metric("loss_treino", final_loss)

        print("--- PASSO 5: Inferência e Cálculo de Anomalias ---")
        model.eval()
        with torch.no_grad():
            reconstructed = model(tensor_x)
            mse_per_row = torch.mean((tensor_x - reconstructed) ** 2, dim=1).numpy()

        df_features['reconstruction_error'] = mse_per_row
        threshold = np.percentile(mse_per_row, 90) if len(mse_per_row) > 1 else 0.0
        df_features['is_anomalia'] = df_features['reconstruction_error'] > threshold

        print("--- PASSO 6: Persistir Resultados Analíticos no PostgreSQL (DW com Histórico) ---")
        create_table_query = """
        CREATE TABLE IF NOT EXISTS fato_anomalias_fornecedor (
            fornecedor_id BIGINT,
            total_agendamentos BIGINT,
            total_cancelados BIGINT,
            media_dias_atraso FLOAT,
            total_insumos_reprovados BIGINT,
            event_timestamp TIMESTAMP,
            reconstruction_error FLOAT,
            is_anomalia BOOLEAN
        );
        """
        
        with engine_dw.begin() as conn:
            conn.execute(text(create_table_query))

        df_features.to_sql(
            'fato_anomalias_fornecedor', 
            con=engine_dw, 
            if_exists='append', 
            index=False
        )
        print("Resultados de anomalias gravados com sucesso na tabela analítica do PostgreSQL!")

        print("--- PASSO 7: Registar o Modelo e Artefactos no MLflow ---")
        model_signature = ModelSignature(
            inputs=Schema([
                TensorSpec(np.dtype(np.float32), (-1, X.shape[1]))
            ]),
            outputs=Schema([
                TensorSpec(np.dtype(np.float32), (-1, X.shape[1]))
            ]),
        )
        mlflow.pytorch.log_model(
            model,
            name="autoencoder_model",
            signature=model_signature,
            input_example=tensor_x[:1].numpy(),
        )
        print("Pipeline MLOps executado de ponta a ponta com sucesso absoluto!")

if __name__ == "__main__":
    executar_pipeline()