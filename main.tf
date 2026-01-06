# Call the Networking Module
module "networking" {
  source = "./modules/networking"

  # Pass variables from root to module
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.environment

  # Pass tags
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

  # Pass outputs from networking module
  vpc_id   = module.networking.vpc_id
  vpc_cidr = module.networking.vpc_cidr

  # Pass common variables
  project_name = var.project_name
  environment  = var.environment

  # Pass tags
  tags = merge(
    var.common_tags,
    {
      Module = "Security"
    }
  )

  # Ensure networking is created first
  depends_on = [module.networking]
}