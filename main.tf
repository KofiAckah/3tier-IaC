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

# Call the Compute Module
module "compute" {
  source = "./modules/compute"

  # Subnet Configuration
  private_app_subnet_ids = module.networking.private_app_subnet_ids

  # Security Group
  security_group_id = module.security.app_sg_id

  # Target Group ARNs
  target_group_arns = [module.alb.target_group_arn]

  # Database Configuration (will be filled after database module is created)
  db_endpoint = "" # Placeholder - will update after database module
  db_name     = "tododb"
  db_username = "admin"
  db_password = "ChangeMe123!" # Temporary - update in tfvars

  # Tags
  environment = var.environment
  project     = var.project_name
  owner       = var.owner

  depends_on = [module.networking, module.security, module.alb]
}