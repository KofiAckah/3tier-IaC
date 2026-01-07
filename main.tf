# Call the Networking Module
module "networking" {
  source = "./modules/networking"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.environment

  tags = merge(
    var.common_tags,
    {
      Module = "Networking"
    }
  )
}

# Call the Security Module
module "security" {
  source = "./modules/security"

  vpc_id   = module.networking.vpc_id
  vpc_cidr = module.networking.vpc_cidr

  project_name = var.project_name
  environment  = var.environment

  tags = merge(
    var.common_tags,
    {
      Module = "Security"
    }
  )

  depends_on = [module.networking]
}

# Call the ALB Module
module "alb" {
  source = "./modules/alb"

  # VPC Configuration
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids

  # Security Group
  web_sg_id = module.security.web_sg_id

  # Project Configuration
  project_name = var.project_name
  environment  = var.environment

  # ALB Configuration
  enable_deletion_protection = false

  # Target Group Configuration
  target_group_port     = 80
  target_group_protocol = "HTTP"

  # Health Check Configuration
  health_check_path                = "/"
  health_check_interval            = 30
  health_check_timeout             = 5
  health_check_healthy_threshold   = 2
  health_check_unhealthy_threshold = 2

  # Target Instance IDs - will be empty initially, filled after compute module
  target_instance_ids = []

  # Tags
  tags = merge(
    var.common_tags,
    {
      Module = "ALB"
    }
  )

  depends_on = [module.networking, module.security]
}

# Call the Database Module
module "database" {
  source = "./modules/database"

  # Network Configuration
  private_db_subnet_ids = module.networking.private_db_subnet_ids
  db_sg_id              = module.security.db_sg_id

  # Project Configuration
  project_name = var.project_name
  environment  = var.environment

  # Database Configuration
  db_engine            = "mysql"
  db_engine_version    = "8.0"
  db_instance_class    = "db.t3.micro"
  db_allocated_storage = 20
  db_storage_type      = "gp3"
  db_storage_encrypted = true

  # Database Credentials
  db_name     = "tododb"
  db_username = "admin"
  db_password = var.db_password

  # Backup Configuration
  db_backup_retention_period = 7
  db_backup_window           = "03:00-04:00"
  db_maintenance_window      = "mon:04:00-mon:05:00"

  # High Availability
  db_multi_az = false

  # Snapshot Configuration
  db_skip_final_snapshot = true

  # Deletion Protection
  db_deletion_protection = false

  # Tags
  tags = merge(
    var.common_tags,
    {
      Module = "Database"
    }
  )

  depends_on = [module.networking, module.security]
}

# Call the Compute Module (Updated with RDS endpoint)
module "compute" {
  source = "./modules/compute"

  # Subnet Configuration
  private_app_subnet_ids = module.networking.private_app_subnet_ids

  # Security Group
  security_group_id = module.security.app_sg_id

  # Target Group ARNs
  target_group_arns = [module.alb.target_group_arn]

  # Database Configuration (NOW CONNECTED TO RDS!)
  db_endpoint = module.database.rds_address
  db_name     = "tododb"
  db_username = "admin"
  db_password = var.db_password

  # Tags
  environment = var.environment
  project     = var.project_name
  owner       = var.owner

  depends_on = [module.networking, module.security, module.alb, module.database]
}