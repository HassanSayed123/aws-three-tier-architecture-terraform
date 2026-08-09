
# resource "aws_db_subnet_group" "db-subnet" {
#   name       = var.db_sub_name
#   subnet_ids = [var.pri_sub_5a_id, var.pri_sub_6b_id] # Replace with your private subnet IDs
# }

# resource "aws_db_instance" "db" {
#   identifier              = "bookdb-instance"
#   engine                  = "mysql"
#   engine_version          = "5.7"
#   instance_class          = "db.t2.micro"
#   allocated_storage       = 20
#   username                = var.db_username
#   password                = var.db_password
#   db_name                 = var.db_name
#   multi_az                = true
#   storage_type            = "gp2"
#   storage_encrypted       = false
#   publicly_accessible     = false
#   skip_final_snapshot     = true
#   backup_retention_period = 0

#   vpc_security_group_ids = [var.db_sg_id] # Replace with your desired security group ID

#   db_subnet_group_name = aws_db_subnet_group.db-subnet.name

#   tags = {
#     Name = "bookdb"
#   }
# }
///////////////////////////////////////////////////////////////////////////////////////////
resource "aws_db_subnet_group" "db-subnet" {
  name = var.db_sub_name
  subnet_ids = [
    var.pri_sub_5a_id,
    var.pri_sub_6b_id
  ]
}

resource "aws_db_instance" "db" {

  identifier = "bookdb-instance"

  engine         = "mysql"
  engine_version = "5.7"

  # instance_class    = "db.t2.micro"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  username = var.db_username
  password = var.db_password
  db_name  = var.db_name

  multi_az          = true
  storage_encrypted = true

  publicly_accessible = false

  # backup_retention_period = 7
  backup_retention_period = 1
  skip_final_snapshot     = true

  vpc_security_group_ids = [
    var.db_sg_id
  ]

  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  tags = {
    Name = "bookdb"
  }
}





////////////////////////////////////////////////////////////////////
resource "aws_elasticache_subnet_group" "cache_subnet" {
  name = "cache-subnet"

  subnet_ids = [
    var.pri_sub_5a_id,
    var.pri_sub_6b_id
  ]
}


resource "aws_elasticache_replication_group" "redis" {

  replication_group_id = "bookshop-redis"

  description = "Redis Cluster"

  engine = "redis"

  node_type = "cache.t3.micro"

  num_cache_clusters = 2

  port = 6379

  subnet_group_name = aws_elasticache_subnet_group.cache_subnet.name

  security_group_ids = [
    var.redis_sg_id
  ]

  at_rest_encryption_enabled = true

  transit_encryption_enabled = true

  automatic_failover_enabled = true

  tags = {
    Name = "bookshop-cache"
  }
}









