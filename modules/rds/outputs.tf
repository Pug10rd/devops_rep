output "db_subnet_group_name" {
  description = "Database subnet group name"
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "Database security group ID"
  value       = aws_security_group.this.id
}

output "endpoint" {
  description = "Database endpoint"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "resource_id" {
  description = "Created DB resource ID"
  value       = var.use_aurora ? aws_rds_cluster.this[0].id : aws_db_instance.this[0].id
}
