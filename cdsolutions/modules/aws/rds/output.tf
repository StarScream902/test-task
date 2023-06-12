output "rds_postgresql_aaddress" {
  value = aws_db_instance.postgresql.address
}

output "rds_postgresql_master_username" {
  value = aws_db_instance.postgresql.username
}
