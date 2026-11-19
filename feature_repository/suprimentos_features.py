from datetime import timedelta
from feast import Entity, Field, FeatureView, ValueType
from feast.types import Float32, Int64
from feast.infra.offline_stores.contrib.postgres_offline_store.postgres_source import PostgreSQLSource

fornecedor_entity = Entity(
    name="fornecedor_id",
    value_type=ValueType.INT64,
    description="ID determinístico derivado do nome do fornecedor",
)

fornecedor_source = PostgreSQLSource(
    name="fornecedor_comportamento_source",
    table="dim_fornecedores",
    timestamp_field="event_timestamp",
)

fornecedor_comportamento_fv = FeatureView(
    name="fornecedor_comportamento_fv",
    entities=[fornecedor_entity],
    ttl=timedelta(days=365),
    schema=[
        Field(name="total_agendamentos", dtype=Int64),
        Field(name="total_cancelados", dtype=Int64),
        Field(name="media_dias_atraso", dtype=Float32),
        Field(name="total_insumos_reprovados", dtype=Int64),
    ],
    online=True,
    source=fornecedor_source,
)