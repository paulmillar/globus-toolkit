-- ----------------------------------------------------
-- DDL Statements for gram audi dataabase schema
-- ----------------------------------------------------

create table gram_audit_table (
    "job_grid_id" varchar(256) primary key,
    "local_job_id" varchar(512),
    "subject_name" varchar(256) not null,
    "username" varchar(16) not null,
    "idempotence_id" varchar(128),
    "creation_time" timestamp not null,
    "queued_time" timestamp,
    "stage_in_grid_id" varchar(256),
    "stage_out_grid_id" varchar(256),
    "clean_up_grid_id" varchar(256),
    "globus_toolkit_version" varchar(16) not null,
    "resource_manager_type" varchar(16) not null,
    "job_description" text not null,
    "success_flag" boolean not null,
    "finished_flag" boolean not null,
    "gateway_user" varchar(256));
