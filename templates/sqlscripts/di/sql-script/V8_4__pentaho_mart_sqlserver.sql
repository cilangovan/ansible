--
-- MSSQL DDL for creating a Pentaho Logging datamart
--
-- ------------------------------------------------------

--
-- Create schema pentaho_operations_mart
--
USE hibernate_di
IF EXISTS(select * from sys.schemas where name='pentaho_operations_mart')
  DROP SCHEMA pentaho_operations_mart
GO
CREATE SCHEMA pentaho_operations_mart
GO

--
-- Definition of table pentaho_operations_mart.dim_batch
--

CREATE TABLE  pentaho_operations_mart.dim_batch (
  batch_tk BIGINT NOT NULL PRIMARY KEY,
  batch_id BIGINT DEFAULT NULL,
  logchannel_id VARCHAR(100) DEFAULT NULL,
  parent_logchannel_id VARCHAR(100) DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_dim_batch_LOOKUP
ON pentaho_operations_mart.dim_batch (batch_id,logchannel_id,parent_logchannel_id);
GO
--
-- Definition of table pentaho_operations_mart.dim_date
--

CREATE TABLE  pentaho_operations_mart.dim_date (
  date_tk INT DEFAULT NULL PRIMARY KEY,
  date_field DATETIME DEFAULT NULL,
  ymd VARCHAR(10) DEFAULT NULL,
  ym VARCHAR(7) DEFAULT NULL,
  year INT DEFAULT NULL,
  quarter INT DEFAULT NULL,
  quarter_code VARCHAR(2) DEFAULT NULL,
  month INT DEFAULT NULL,
  month_desc VARCHAR(20) DEFAULT NULL,
  month_code VARCHAR(15) DEFAULT NULL,
  day INT DEFAULT NULL,
  day_of_year INT DEFAULT NULL,
  day_of_week INT DEFAULT NULL,
  day_of_week_desc VARCHAR(20) DEFAULT NULL,
  day_of_week_code VARCHAR(15) DEFAULT NULL,
  week INT DEFAULT NULL
) ON [PRIMARY]
GO

--
-- Definition of table pentaho_operations_mart.dim_execution
--

CREATE TABLE  pentaho_operations_mart.dim_execution (
  execution_tk BIGINT NOT NULL PRIMARY KEY,
  execution_id VARCHAR(100) DEFAULT NULL,
  server_host VARCHAR(100) DEFAULT NULL,
  executing_user VARCHAR(100) DEFAULT NULL,
  execution_status VARCHAR(30) DEFAULT NULL,
  client VARCHAR(255) DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_dim_execution_LOOKUP
ON pentaho_operations_mart.dim_execution (execution_id,server_host,executing_user,client);
GO
--
-- Definition of table pentaho_operations_mart.dim_executor
--

CREATE TABLE  pentaho_operations_mart.dim_executor (
  executor_tk BIGINT NOT NULL PRIMARY KEY,
  version INT DEFAULT NULL,
  date_from DATETIME DEFAULT NULL,
  date_to DATETIME DEFAULT NULL,
  executor_id VARCHAR(255) DEFAULT NULL,
  executor_source VARCHAR(255) DEFAULT NULL,
  executor_environment VARCHAR(255) DEFAULT NULL,
  executor_type VARCHAR(255) DEFAULT NULL,
  executor_name VARCHAR(255) DEFAULT NULL,
  executor_desc VARCHAR(255) DEFAULT NULL,
  executor_revision VARCHAR(255) DEFAULT NULL,
  executor_version_label VARCHAR(255) DEFAULT NULL,
  exec_enabled_table_logging CHAR(1) DEFAULT NULL,
  exec_enabled_detailed_logging CHAR(1) DEFAULT NULL,
  exec_enabled_perf_logging CHAR(1) DEFAULT NULL,
  exec_enabled_history_logging CHAR(1) DEFAULT NULL,
  last_updated_date DATETIME DEFAULT NULL,
  last_updated_user VARCHAR(255) DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_dim_executor_LOOKUP
ON pentaho_operations_mart.dim_executor (executor_id);
GO
--
-- Definition of table pentaho_operations_mart.dim_time
--

CREATE TABLE  pentaho_operations_mart.dim_time (
  time_tk INT DEFAULT NULL PRIMARY KEY,
  hms VARCHAR(8) DEFAULT NULL,
  hm VARCHAR(5) DEFAULT NULL,
  ampm VARCHAR(8) DEFAULT NULL,
  hour INT DEFAULT NULL,
  hour12 INT DEFAULT NULL,
  minute INT DEFAULT NULL,
  second INT DEFAULT NULL
) ON [PRIMARY]
GO
--
-- Definition of table pentaho_operations_mart.dim_log_table
--

CREATE TABLE  pentaho_operations_mart.dim_log_table (
  log_table_tk BIGINT NOT NULL PRIMARY KEY,
  object_type VARCHAR(30) DEFAULT NULL,
  table_connection_name VARCHAR(255) DEFAULT NULL,
  table_name VARCHAR(255) DEFAULT NULL,
  schema_name VARCHAR(255) DEFAULT NULL,
  step_entry_table_conn_name VARCHAR(255) DEFAULT NULL,
  step_entry_table_name VARCHAR(255) DEFAULT NULL,
  step_entry_schema_name VARCHAR(255) DEFAULT NULL,
  perf_table_conn_name VARCHAR(255) DEFAULT NULL,
  perf_table_name VARCHAR(255) DEFAULT NULL,
  perf_schema_name VARCHAR(255) DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX idx_dim_log_table_lookup
ON pentaho_operations_mart.dim_log_table (object_type, table_connection_name, table_name, schema_name);
GO
CREATE INDEX idx_dim_log_step_entry_table_lookup
ON pentaho_operations_mart.dim_log_table (object_type, step_entry_table_conn_name, step_entry_table_name, step_entry_schema_name);
GO
CREATE INDEX idx_dim_log_perf_table_lookup
ON pentaho_operations_mart.dim_log_table (object_type, perf_table_conn_name, perf_table_name, perf_schema_name);
GO
--
-- Definition of table pentaho_operations_mart.dim_log_table
--

CREATE TABLE  pentaho_operations_mart.dim_step (
  step_tk BIGINT NOT NULL PRIMARY KEY,
  step_id VARCHAR(255) DEFAULT NULL,
  original_step_name VARCHAR(255) DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX idx_dim_step_lookup
ON pentaho_operations_mart.dim_step (step_id);
GO
--
-- Definition of table pentaho_operations_mart.fact_execution
--

CREATE TABLE  pentaho_operations_mart.fact_execution (
  execution_date_tk INT DEFAULT NULL,
  execution_time_tk INT DEFAULT NULL,
  batch_tk INT DEFAULT NULL,
  execution_tk INT DEFAULT NULL,
  executor_tk INT DEFAULT NULL,
  parent_executor_tk INT DEFAULT NULL,
  root_executor_tk INT DEFAULT NULL,
  execution_timestamp DATETIME DEFAULT NULL,
  duration float(53) DEFAULT NULL,
  rows_input INT DEFAULT NULL,
  rows_output INT DEFAULT NULL,
  rows_read INT DEFAULT NULL,
  rows_written INT DEFAULT NULL,
  rows_rejected INT DEFAULT NULL,
  errors INT DEFAULT NULL,
  failed INT DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_fact_execution_EXECUTION_DATE_TK
ON pentaho_operations_mart.fact_execution (execution_date_tk);
GO
CREATE INDEX IDX_fact_execution_EXECUTION_TIME_TK
ON pentaho_operations_mart.fact_execution (execution_time_tk);
GO
CREATE INDEX IDX_fact_execution_BATCH_TK
ON pentaho_operations_mart.fact_execution (batch_tk);
GO
CREATE INDEX IDX_fact_execution_EXECUTION_TK
ON pentaho_operations_mart.fact_execution (execution_tk);
GO
CREATE INDEX IDX_fact_execution_EXECUTOR_TK
ON pentaho_operations_mart.fact_execution (executor_tk);
GO
CREATE INDEX IDX_fact_execution_PARENT_EXECUTOR_TK
ON pentaho_operations_mart.fact_execution (parent_executor_tk);
GO
CREATE INDEX IDX_fact_execution_ROOT_EXECUTOR_TK
ON pentaho_operations_mart.fact_execution (root_executor_tk);
GO
--
-- Definition of table pentaho_operations_mart.FACT_STEP_EXECUTION
--

CREATE TABLE  pentaho_operations_mart.fact_step_execution (
  execution_date_tk INT DEFAULT NULL,
  execution_time_tk INT DEFAULT NULL,
  batch_tk INT DEFAULT NULL,
  executor_tk INT DEFAULT NULL,
  parent_executor_tk INT DEFAULT NULL,
  root_executor_tk INT DEFAULT NULL,
  step_tk INT DEFAULT NULL,
  step_copy INT DEFAULT NULL,
  execution_timestamp DATETIME DEFAULT NULL,
  rows_input INT DEFAULT NULL,
  rows_output INT DEFAULT NULL,
  rows_read INT DEFAULT NULL,
  rows_written INT DEFAULT NULL,
  rows_rejected INT DEFAULT NULL,
  errors INT DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTION_DATE_TK ON pentaho_operations_mart.fact_step_execution(execution_date_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTION_TIME_TK ON pentaho_operations_mart.fact_step_execution(execution_time_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_BATCH_TK ON pentaho_operations_mart.fact_step_execution(batch_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTOR_TK ON pentaho_operations_mart.fact_step_execution(executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_PARENT_EXECUTOR_TK ON pentaho_operations_mart.fact_step_execution(parent_executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_ROOT_EXECUTOR_TK ON pentaho_operations_mart.fact_step_execution(root_executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_STEP_TK ON pentaho_operations_mart.fact_step_execution(step_tk);
GO
--
-- Definition of table pentaho_operations_mart.FACT_JOBENTRY_EXECUTION
--

CREATE TABLE  pentaho_operations_mart.fact_jobentry_execution (
  execution_date_tk INT DEFAULT NULL,
  execution_time_tk INT DEFAULT NULL,
  batch_tk INT DEFAULT NULL,
  executor_tk INT DEFAULT NULL,
  parent_executor_tk INT DEFAULT NULL,
  root_executor_tk INT DEFAULT NULL,
  step_tk INT DEFAULT NULL,
  execution_timestamp DATETIME DEFAULT NULL,
  rows_input INT DEFAULT NULL,
  rows_output INT DEFAULT NULL,
  rows_read INT DEFAULT NULL,
  rows_written INT DEFAULT NULL,
  rows_rejected INT DEFAULT NULL,
  errors INT DEFAULT NULL,
  result CHAR(1) DEFAULT NULL,
  nr_result_rows INT DEFAULT NULL,
  nr_result_files INT DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTION_DATE_TK ON pentaho_operations_mart.fact_jobentry_execution(execution_date_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTION_TIME_TK ON pentaho_operations_mart.fact_jobentry_execution(execution_time_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_BATCH_TK ON pentaho_operations_mart.fact_jobentry_execution(batch_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTOR_TK ON pentaho_operations_mart.fact_jobentry_execution(executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_PARENT_EXECUTOR_TK ON pentaho_operations_mart.fact_jobentry_execution(parent_executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_ROOT_EXECUTOR_TK ON pentaho_operations_mart.fact_jobentry_execution(root_executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_STEP_TK ON pentaho_operations_mart.fact_jobentry_execution(step_tk);
GO
--
-- Definition of table pentaho_operations_mart.FACT_PERF_EXECUTION
--

CREATE TABLE  pentaho_operations_mart.fact_perf_execution (
  execution_date_tk INT DEFAULT NULL,
  execution_time_tk INT DEFAULT NULL,
  batch_tk INT DEFAULT NULL,
  executor_tk INT DEFAULT NULL,
  parent_executor_tk INT DEFAULT NULL,
  root_executor_tk INT DEFAULT NULL,
  step_tk INT DEFAULT NULL,
  seq_nr INT DEFAULT NULL,
  step_copy INT DEFAULT NULL,
  execution_timestamp DATETIME DEFAULT NULL,
  rows_input INT DEFAULT NULL,
  rows_output INT DEFAULT NULL,
  rows_read INT DEFAULT NULL,
  rows_written INT DEFAULT NULL,
  rows_rejected INT DEFAULT NULL,
  errors INT DEFAULT NULL,
  input_buffer_rows INT DEFAULT NULL,
  output_buffer_rows INT DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_FACT_PERF_EXECUTION_EXECUTION_DATE_TK ON pentaho_operations_mart.fact_perf_execution(execution_date_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_EXECUTION_TIME_TK ON pentaho_operations_mart.fact_perf_execution(execution_time_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_BATCH_TK ON pentaho_operations_mart.fact_perf_execution(batch_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_EXECUTION_TK ON pentaho_operations_mart.fact_perf_execution(step_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_EXECUTOR_TK ON pentaho_operations_mart.fact_perf_execution(executor_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_PARENT_EXECUTOR_TK ON pentaho_operations_mart.fact_perf_execution(parent_executor_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_ROOT_EXECUTOR_TK ON pentaho_operations_mart.fact_perf_execution(root_executor_tk);
GO

CREATE TABLE  pentaho_operations_mart.dim_state (
  state_tk BIGINT NOT NULL PRIMARY KEY,
  state VARCHAR(100) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE  pentaho_operations_mart.dim_session (
  session_tk BIGINT NOT NULL PRIMARY KEY,
  session_id VARCHAR(200) NOT NULL,
  session_type VARCHAR(200) NOT NULL,
  username VARCHAR(200) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE  pentaho_operations_mart.dim_instance (
  instance_tk BIGINT NOT NULL PRIMARY KEY,
  instance_id VARCHAR(200) NOT NULL,
  engine_id VARCHAR(200) NOT NULL,
  service_id VARCHAR(200) NOT NULL,
  content_id VARCHAR(200) NOT NULL,
  content_detail VARCHAR(1024) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE  pentaho_operations_mart.dim_component (
  component_tk BIGINT NOT NULL PRIMARY KEY,
  component_id VARCHAR(200) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE pentaho_operations_mart.stg_content_item (
  gid CHAR(36) NOT NULL PRIMARY KEY,
  parent_gid CHAR(36) DEFAULT NULL,
  fileSize INT NOT NULL,
  locale VARCHAR(5) DEFAULT NULL,
  name VARCHAR(200) NOT NULL,
  ownerType tinyint NOT NULL,
  path VARCHAR(1024) NOT NULL,
  title VARCHAR(255) DEFAULT NULL,
  is_folder CHAR(1) NOT NULL,
  is_hidden CHAR(1) NOT NULL,
  is_locked CHAR(1) NOT NULL,
  is_versioned CHAR(1) NOT NULL,
  date_created DATETIME NULL,
  date_last_modified DATETIME NULL,
  is_processed CHAR(1) DEFAULT NULL
) ON [PRIMARY]
GO

CREATE INDEX gid ON pentaho_operations_mart.stg_content_item(parent_gid);
GO

CREATE TABLE pentaho_operations_mart.dim_content_item (
  content_item_tk INT NOT NULL PRIMARY KEY,
  content_item_title VARCHAR(255) NOT NULL DEFAULT 'NA',
  content_item_locale VARCHAR(255) NOT NULL DEFAULT 'NA',
  content_item_size INT NOT NULL DEFAULT 0,
  content_item_path VARCHAR(1024) NOT NULL DEFAULT 'NA',
  content_item_name VARCHAR(255) NOT NULL DEFAULT 'NA',
  content_item_fullname VARCHAR(1024) NOT NULL DEFAULT 'NA',
  content_item_type VARCHAR(32) NOT NULL DEFAULT 'NA',
  content_item_extension VARCHAR(32) NOT NULL DEFAULT 'NA',
  content_item_guid CHAR(36) NOT NULL DEFAULT 'NA',
  parent_content_item_guid CHAR(36) NULL DEFAULT 'NA',
  parent_content_item_tk INT NULL,
  content_item_modified DATETIME NOT NULL DEFAULT '1900-01-01 00:00:00',
  content_item_valid_from DATETIME NOT NULL DEFAULT '1900-01-01 00:00:00',
  content_item_valid_to DATETIME NOT NULL DEFAULT '9999-12-31 23:59:59',
  content_item_state VARCHAR(16) NOT NULL DEFAULT 'new',
  content_item_version INT NOT NULL DEFAULT 0
) ON [PRIMARY]
GO

CREATE INDEX IDX_dim_content_item_LOOKUP ON pentaho_operations_mart.dim_content_item(content_item_guid, content_item_valid_from);
GO

CREATE TABLE  pentaho_operations_mart.fact_session (
  start_date_tk INT NOT NULL,
  start_time_tk INT NOT NULL,
  end_date_tk INT NOT NULL,
  end_time_tk INT NOT NULL,
  session_tk BIGINT NOT NULL,
  state_tk BIGINT NOT NULL,
  duration NUMERIC(19,3) NOT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_FACT_PERF_SESSION_START_DATE_TK ON pentaho_operations_mart.fact_session(start_date_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_START_TIME_TK  ON pentaho_operations_mart.fact_session(start_time_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_END_DATE_TK  ON pentaho_operations_mart.fact_session(end_date_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_END_TIME_TK  ON pentaho_operations_mart.fact_session(end_time_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_SESSION_TK  ON pentaho_operations_mart.fact_session(session_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_STATE_TK  ON pentaho_operations_mart.fact_session(state_tk);
GO

CREATE TABLE  pentaho_operations_mart.fact_instance (
  start_date_tk INT NOT NULL,
  start_time_tk INT NOT NULL,
  end_date_tk INT NOT NULL,
  end_time_tk INT NOT NULL,
  session_tk BIGINT NOT NULL,
  instance_tk BIGINT NOT NULL,
  state_tk BIGINT NOT NULL,
  duration NUMERIC(19,3) NOT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_FACT_PERF_INSTANCE_START_DATE_TK ON pentaho_operations_mart.fact_instance(start_date_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_START_TIME_TK  ON pentaho_operations_mart.fact_instance(start_time_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_END_DATE_TK  ON pentaho_operations_mart.fact_instance(end_date_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_END_TIME_TK  ON pentaho_operations_mart.fact_instance(end_time_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_SESSION_TK  ON pentaho_operations_mart.fact_instance(session_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_INSTANCE_TK  ON pentaho_operations_mart.fact_instance(instance_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_STATE_TK  ON pentaho_operations_mart.fact_instance(state_tk);
GO

CREATE TABLE  pentaho_operations_mart.fact_component (
  start_date_tk INT NOT NULL,
  start_time_tk INT NOT NULL,
  end_date_tk INT NOT NULL,
  end_time_tk INT NOT NULL,
  session_tk BIGINT NOT NULL,
  instance_tk BIGINT NOT NULL,
  state_tk BIGINT NOT NULL,
  component_tk BIGINT NOT NULL,
  duration NUMERIC(19,3) NOT NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_FACT_PERF_COMPONENT_START_DATE_TK ON pentaho_operations_mart.fact_component(start_date_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_START_TIME_TK  ON pentaho_operations_mart.fact_component(start_time_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_END_DATE_TK  ON pentaho_operations_mart.fact_component(end_date_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_END_TIME_TK  ON pentaho_operations_mart.fact_component(end_time_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_SESSION_TK  ON pentaho_operations_mart.fact_component(session_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_INSTANCE_TK  ON pentaho_operations_mart.fact_component(instance_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_COMPONENT_TK  ON pentaho_operations_mart.fact_component(component_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_STATE_TK  ON pentaho_operations_mart.fact_component(state_tk);
GO

CREATE TABLE pentaho_operations_mart.pro_audit_staging (
  job_id VARCHAR(200),
  inst_id VARCHAR(200),
  obj_id VARCHAR(200),
  obj_type VARCHAR(200),
  actor VARCHAR(200),
  message_type VARCHAR(200),
  message_name VARCHAR(200),
  message_text_value VARCHAR(1024),
  message_num_value NUMERIC(19),
  duration NUMERIC(19, 3),
  audit_time DATETIME NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_PRO_AUDIT_STAGING_MESSAGE_TYPE  ON pentaho_operations_mart.pro_audit_staging(message_type);
GO

CREATE TABLE pentaho_operations_mart.pro_audit_tracker (
  audit_time DATETIME NULL
) ON [PRIMARY]
GO

CREATE INDEX IDX_PRO_AUDIT_TRACKER_AUDIT_TIME  ON pentaho_operations_mart.pro_audit_tracker(audit_time);
GO

INSERT INTO pentaho_operations_mart.pro_audit_tracker values ('1970-01-01 00:00:01');
GO
