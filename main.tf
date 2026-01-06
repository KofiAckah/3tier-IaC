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