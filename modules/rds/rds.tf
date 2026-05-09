resource "aws_db_parameter_group" "this" {
  count  = var.use_aurora ? 0 : 1
  name   = "${var.name_prefix}-db-pg"
  family = var.parameter_group_family

  parameter {
    name         = "max_connections"
    value        = var.max_connections
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_statement"
    value        = var.log_statement
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "work_mem"
    value        = var.work_mem
    apply_method = "pending-reboot"
  }

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-db-pg"
  })
}

resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier             = "${var.name_prefix}-db"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  port                   = var.port
  multi_az               = var.multi_az
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name = var.use_aurora ? null : aws_db_parameter_group.this[0].name
  skip_final_snapshot    = var.skip_final_snapshot

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-db"
  })
}
