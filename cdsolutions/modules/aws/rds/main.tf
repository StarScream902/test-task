data "aws_caller_identity" "current" {}

resource "aws_iam_group" "rds_group" {
  name = "${lower(var.environment.short)}-${var.name}-rds-log-files-readers"
}

resource "aws_iam_group_policy" "rds_group_policy" {
  name  = "${lower(var.environment.short)}-${var.name}-rds-log-files-allow-read"
  group = aws_iam_group.rds_group.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
          "rds:DownloadDBLogFilePortion",
          "rds:DescribeDBLogFiles"
      ],
      "Resource": "arn:aws:rds:*:${data.aws_caller_identity.current.account_id}:db:*"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": "rds:DownloadCompleteDBLogFile",
      "Resource": "*"
    }
  ]
}
EOF
}

locals {
  subnet_group_main_name = lower("${var.environment.short}-${var.name}-subnet-group")
}

resource "aws_security_group" "database_sg" {

  name   = title("${var.environment.short}-${var.name}-Database")
  vpc_id = var.vpc_id

  tags = {
    Name        = title("${var.environment.short}-${var.name}-Database")
    Environment = lower(var.environment.full)
  }
}

resource "aws_security_group_rule" "database_allow_ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.database_sg.id
  cidr_blocks       = var.allow_cidrs
}

resource "aws_security_group_rule" "database_allow_peer_ingress" {

  count = length(var.peer_cidrs)

  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.database_sg.id
  cidr_blocks = [
    var.peer_cidrs[count.index]
  ]
}

resource "aws_db_subnet_group" "main" {
  name       = local.subnet_group_main_name
  subnet_ids = var.subnet_ids

  tags = {
    Name        = title(local.subnet_group_main_name)
    Environment = lower(var.environment.full)
  }
}

resource "random_string" "master_password" {
  length  = 18
  upper   = true
  lower   = true
  numeric = true
  special = false
}

resource "aws_kms_key" "rds_key" {
  description = "${title(var.environment.short)} ${title(var.name)} RDS PosgreSQL Key"
}

resource "aws_kms_alias" "rds_key_alias" {
  name          = lower("alias/${var.environment.short}-${var.name}-rds-postgresql-key")
  target_key_id = aws_kms_key.rds_key.key_id
}

resource "aws_secretsmanager_secret" "postgresql_master_password" {
  name       = lower("${var.environment.short}-${var.name}-rds-postgresql-master-password")
  kms_key_id = aws_kms_key.rds_key.key_id

  tags = {
    Name        = title("${var.environment.short}-${var.name}-RDS-PostgreSQL-Master-Password")
    Environment = lower(var.environment.full)
  }
}

resource "aws_secretsmanager_secret_version" "postgresql_master_password" {
  secret_id     = aws_secretsmanager_secret.postgresql_master_password.id
  secret_string = random_string.master_password.result
}

locals {
  rds_family_version  = split(".", var.engine_version)[0]
  rds_postgres_family = "${var.engine_pg}${local.rds_family_version}"
  rds_parameters = {
    log_min_duration_statement : "1024"
    log_lock_waits : "1"
    log_temp_files : "1024"
  }
}

resource "aws_db_parameter_group" "instance_postgres" {
  name        = lower("${var.environment.short}-${var.name}-instance-${local.rds_postgres_family}")
  family      = local.rds_postgres_family
  description = "RDS ${var.environment.short} ${var.name} instance parameter group"

  dynamic "parameter" {
    for_each = local.rds_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

resource "aws_db_instance" "postgresql" {
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp2"

  engine         = var.engine_pg
  engine_version = var.engine_version

  instance_class = var.instance_class

  identifier = lower("${var.environment.short}-${var.name}")

  db_name  = "${lower(var.environment.short)}${title(var.name)}"
  username = var.postgres_master_username
  password = random_string.master_password.result

  multi_az                     = true
  auto_minor_version_upgrade   = false
  deletion_protection          = true
  performance_insights_enabled = var.performance_insights_enabled

  parameter_group_name = aws_db_parameter_group.instance_postgres.name

  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds_key.arn

  monitoring_interval = 0

  publicly_accessible  = false
  db_subnet_group_name = local.subnet_group_main_name
  availability_zone    = var.availability_zone

  skip_final_snapshot = true
  apply_immediately   = false

  vpc_security_group_ids = [
    aws_security_group.database_sg.id
  ]

  tags = {
    Name        = title("${var.environment.short}-${var.name}-PostgreSQL")
    Environment = lower(var.environment.full)
  }
}
