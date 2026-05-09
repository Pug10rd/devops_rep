resource "aws_rds_cluster_parameter_group" "this" {
  count  = var.use_aurora ? 1 : 0
  name   = "${var.name_prefix}-cluster-pg"
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
    Name = "${var.name_prefix}-cluster-pg"
  })
}

resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier              = "${var.name_prefix}-cluster"
  engine                          = var.engine
  engine_version                  = var.engine_version
  database_name                   = var.db_name
  master_username                 = var.username
  master_password                 = var.password
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this[0].name
  skip_final_snapshot             = var.skip_final_snapshot

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-cluster"
  })
}

resource "aws_rds_cluster_instance" "writer" {
  count = var.use_aurora ? 1 : 0

  identifier         = "${var.name_prefix}-writer"
  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = var.engine
  engine_version     = var.engine_version

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-writer"
  })
}
