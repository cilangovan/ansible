use hibernate;

IF OBJECT_ID(N'pentaho_operations_mart.dim_batch', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.dim_batch;
IF OBJECT_ID(N'pentaho_operations_mart.dim_date', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.dim_date;
IF OBJECT_ID(N'pentaho_operations_mart.dim_execution', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.dim_execution;
IF OBJECT_ID(N'pentaho_operations_mart.dim_executor', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.dim_executor;
IF OBJECT_ID(N'pentaho_operations_mart.dim_time', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.dim_time;
IF OBJECT_ID(N'pentaho_operations_mart.dim_log_table', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.dim_log_table;
IF OBJECT_ID(N'pentaho_operations_mart.dim_step', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.dim_step;
IF OBJECT_ID(N'pentaho_operations_mart.fact_execution', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.fact_execution;
IF OBJECT_ID(N'pentaho_operations_mart.fact_step_execution', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.fact_step_execution;
IF OBJECT_ID(N'pentaho_operations_mart.fact_jobentry_execution', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.fact_jobentry_execution;
IF OBJECT_ID(N'pentaho_operations_mart.fact_perf_execution', N'U') IS NOT NULL
DROP TABLE pentaho_operations_mart.fact_perf_execution;

IF OBJECT_ID(N'pentaho_operations_mart.DIM_STATE', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.DIM_STATE;
IF OBJECT_ID(N'pentaho_operations_mart.DIM_SESSION', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.DIM_SESSION;
IF OBJECT_ID(N'pentaho_operations_mart.DIM_INSTANCE', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.DIM_INSTANCE;
IF OBJECT_ID(N'pentaho_operations_mart.DIM_COMPONENT', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.DIM_COMPONENT;
IF OBJECT_ID(N'pentaho_operations_mart.STG_CONTENT_ITEM', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.STG_CONTENT_ITEM;
IF OBJECT_ID(N'pentaho_operations_mart.DIM_CONTENT_ITEM', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.DIM_CONTENT_ITEM;
IF OBJECT_ID(N'pentaho_operations_mart.FACT_SESSION', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.FACT_SESSION;
IF OBJECT_ID(N'pentaho_operations_mart.FACT_INSTANCE', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.FACT_INSTANCE;
IF OBJECT_ID(N'pentaho_operations_mart.FACT_COMPONENT', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.FACT_COMPONENT;
IF OBJECT_ID(N'pentaho_operations_mart.PRO_AUDIT_STAGING', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.PRO_AUDIT_STAGING;
IF OBJECT_ID(N'pentaho_operations_mart.PRO_AUDIT_TRACKER', N'U') IS NOT NULL
  DROP TABLE pentaho_operations_mart.PRO_AUDIT_TRACKER;