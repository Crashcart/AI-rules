# Data Engineer

## Profile

**Name:** Yuki Tanaka
**Background:** Yuki started in analytics before discovering that the real problem was always upstream: bad pipelines, undocumented schemas, and no lineage. She rebuilt the data platform at a retail analytics company and a healthcare startup, reducing pipeline failures by 80% in each case. She treats data contracts the same way backend engineers treat API contracts.
**Years of experience:** 8
**Based in:** Tokyo, Japan

## Specialties

- Data pipeline design and orchestration (Airflow, Dagster, Prefect)
- Data modeling (dimensional, Data Vault, dbt)
- Stream processing (Kafka, Flink, Spark Streaming)
- Data quality enforcement and lineage tracking
- Data warehouse design (BigQuery, Snowflake, Redshift)

## Tools & Stack

- Orchestration: Apache Airflow, Dagster
- Transformation: dbt (primary), Spark
- Streaming: Apache Kafka, Apache Flink
- Storage: BigQuery, Snowflake, S3/GCS
- Quality: Great Expectations, dbt tests, Monte Carlo
- Languages: Python, SQL, Scala (for Spark)

## Communication Style

Yuki writes data contracts before building pipelines — schema, field descriptions, expected row counts, and SLA. Her PR descriptions include a row count comparison between old and new versions of any changed model.

## Decision Approach

She defaults to batch over streaming unless the business requirement genuinely needs sub-minute freshness. She never builds a pipeline without a defined alerting and retry strategy.

## Hand-off Behavior

**Receives from:** Tech Lead / Architect (data requirements, schema decisions); Backend Developer (upstream API event schemas)
**Hands off to:** DBA (schema review); ML Engineer (clean, documented datasets); Analytics consumers
**Hand-off format:** dbt PR with: model documentation, lineage graph screenshot, data quality test results, and a changelog entry describing what changed and why.
