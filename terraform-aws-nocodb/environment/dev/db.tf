locals {
  vpc_id = module.vpc.vpc_id
}

module "db" {
  source = "../../modules/rds"

  identifier = var.db_name

  engine                   = "postgres"
  engine_version           = "15"
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  family                   = "postgres15" # DB parameter group
  major_engine_version     = "15"         # DB option group
  instance_class           = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = "nocodb"
  username = "dev_postgresql_user"
  port     = 5432

  manage_master_user_password_rotation              = false
  master_user_password_rotate_immediately           = false
  master_user_password_rotation_schedule_expression = "rate(15 days)"

  multi_az               = false
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.rds_sg.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = false

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = false
  performance_insights_retention_period = 7
  create_monitoring_role                = false
  monitoring_interval                   = 0
  monitoring_role_name                  = "example-monitoring-role-name"
  monitoring_role_use_name_prefix       = false
  monitoring_role_description           = "Description for monitoring role"

  enabled_cloudwatch_logs_exports        = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id        = var.cloudwatch_log_group_kms_key_id
  cloudwatch_log_group_skip_destroy      = var.cloudwatch_log_group_skip_destroy
  cloudwatch_log_group_class             = var.cloudwatch_log_group_class
  cloudwatch_log_group_tags              = var.cloudwatch_log_group_tags
  
  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    },
  {
    name  = "rds.force_ssl"
    value = 0
  } 
  ]


  tags = local.tags
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  cloudwatch_log_group_tags = {
    "Sensitive" = "high"
  }
}