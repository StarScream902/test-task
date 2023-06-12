variable "environment" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "allow_cidrs" {
  type = list(string)
}

variable "peer_cidrs" {
  type    = list(string)
  default = []
}

variable "subnet_ids" {
  type = list(string)
}

variable "availability_zone" {
  type = string
  default = null
}

variable "engine_pg" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t4g.small"
}

variable "postgres_master_username" {
  type    = string
  default = "postgresadministrator"
}

variable "backup_retention_period" {
  type    = number
  default = 5
}

variable "preferred_backup_window" {
  type    = string
  default = "01:00-02:00"
}

variable "preferred_maintenance_window" {
  type    = string
  default = "Mon:02:00-Mon:04:00"
}

variable "name" {
  type = string
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 0
}

variable "performance_insights_enabled" {
  type = bool
  default = false
}