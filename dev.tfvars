# Environment Configuration
environment  = "dev"
project_name = "3tier-iac"
owner        = "joel-livingstone-kofi-ackah"

# AWS Configuration
aws_region  = "eu-central-1"
aws_profile = "terraform-localAdmin"

# Networking Configuration
vpc_cidr = "10.0.0.0/16"

# Common Tags
common_tags = {
  ManagedBy   = "Terraform"
  Environment = "dev"
  CostCenter  = "Development"
  Department  = "Engineering"
}