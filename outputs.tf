# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "List of private application subnet IDs"
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "List of private database subnet IDs"
  value       = module.networking.private_db_subnet_ids
}

# Gateway Outputs
output "nat_gateway_public_ip" {
  description = "Public IP of the NAT Gateway"
  value       = module.networking.nat_gateway_public_ip
}

output "availability_zones" {
  description = "Availability zones used"
  value       = module.networking.availability_zones
}