output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "database_subnets" {
  value = aws_subnet.database
}

output "database_subnet_ids" {
  value = [
    for s in aws_subnet.database:
      s.id
  ]
}
