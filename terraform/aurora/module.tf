
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2" 
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = "aurora-cluster-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_security_group = true
  default_security_group_ingress = [
  {
    self        = "false"
    cidr_blocks = "0.0.0.0/0"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH from anywhere"
  },
  {
    self        = "true"
    cidr_blocks = ""
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow all traffic from self"
  }
  ]
  default_security_group_egress= [
  {
    cidr_blocks = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow outbound traffic to anywhere"
  }
  ]

  tags = local.tags
}

module "rds-aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.11.0"

  name            = "main-cluster"
  engine          = "aurora-mysql"
  engine_version  = "8.0"
  master_username = local.rds_master_user
  master_password = local.rds_master_pwd
  instances = {
    1 = {
      identifier     = "main"
      instance_class = "db.t3.small"
    }
  }

  vpc_id               = module.vpc.vpc_id
  vpc_security_group_ids = ["module.vpc.default_security_group_id"]
  db_subnet_group_name = module.vpc.database_subnet_group_name

  apply_immediately   = true
  skip_final_snapshot = true

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "${local.name}-cluster"
  db_cluster_parameter_group_family      = "aurora-mysql5.7"
  db_cluster_parameter_group_description = "${local.name} example cluster parameter group"
  db_cluster_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 120
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "immediate"
      }, {
      name         = "max_allowed_packet"
      value        = "67108864"
      apply_method = "immediate"
      },{
      name         = "binlog_format"
      value        = "ROW"
      apply_method = "immediate"
      }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = "${local.name}-instance"
  db_parameter_group_family      = "aurora-mysql5.7"
  db_parameter_group_description = "${local.name} example DB parameter group"
  db_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 60
      apply_method = "immediate"
      }, {
      name         = "general_log"
      value        = 0
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "pending-reboot"
      }, {
      name         = "long_query_time"
      value        = 5
      apply_method = "immediate"
      }, {
      name         = "max_connections"
      value        = 2000
      apply_method = "immediate"
      }, {
      name         = "slow_query_log"
      value        = 1
      apply_method = "immediate"
      }
  ]

  tags = local.tags
}



# module "db" {
#   source = "terraform-aws-modules/vpc/rds"
#   version = "6.10.0"

#   identifier = main-cluster

#   # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
#   engine               = "aurora-mysql"
#   engine_version       = "5.7.mysql_aurora.2.11.5"
#   family               = "aurora-mysql5.7" # DB parameter group
#   major_engine_version = "5.7"      # DB option group
#   instance_class       = "db.t3.small"

#   allocated_storage     = 20
#   max_allocated_storage = 100

#   db_name  = "completeMysql"
#   username = "complete_mysql"
#   port     = 3306

#   multi_az               = true
#   db_subnet_group_name   = module.vpc.database_subnet_group
#   vpc_security_group_ids = [module.security_group.security_group_id]

#   maintenance_window              = "Mon:00:00-Mon:03:00"
#   backup_window                   = "03:00-06:00"
#   enabled_cloudwatch_logs_exports = ["general"]
#   create_cloudwatch_log_group     = true

#   skip_final_snapshot = true
#   deletion_protection = false

#   performance_insights_enabled          = true
#   performance_insights_retention_period = 7
#   create_monitoring_role                = true
#   monitoring_interval                   = 60

#   parameters = [
#     {
#       name  = "character_set_client"
#       value = "utf8mb4"
#     },
#     {
#       name  = "character_set_server"
#       value = "utf8mb4"
#     }
#   ]

#   tags = local.tags
#   db_instance_tags = {
#     "Sensitive" = "high"
#   }
#   db_option_group_tags = {
#     "Sensitive" = "low"
#   }
#   db_parameter_group_tags = {
#     "Sensitive" = "low"
#   }
#   db_subnet_group_tags = {
#     "Sensitive" = "high"
#   }
#   cloudwatch_log_group_tags = {
#     "Sensitive" = "high"
#   }
# }
