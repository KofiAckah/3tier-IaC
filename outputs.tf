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

# Security Group Outputs
output "web_sg_id" {
  description = "ID of the Web security group"
  value       = module.security.web_sg_id
}

output "app_sg_id" {
  description = "ID of the App security group"
  value       = module.security.app_sg_id
}

output "db_sg_id" {
  description = "ID of the DB security group"
  value       = module.security.db_sg_id
}

output "all_security_groups" {
  description = "All security group IDs"
  value       = module.security.all_sg_ids
}

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.alb.target_group_arn
}

output "alb_info" {
  description = "Complete ALB information"
  value       = module.alb.alb_info
}

# Compute Outputs
output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = module.compute.instance_ids
}

output "instance_1_id" {
  description = "ID of EC2 instance 1"
  value       = module.compute.instance_1_id
}

output "instance_2_id" {
  description = "ID of EC2 instance 2"
  value       = module.compute.instance_2_id
}

# Summary Output
output "deployment_summary" {
  description = "Complete deployment summary"
  value = {
    vpc_id         = module.networking.vpc_id
    alb_dns        = module.alb.alb_dns_name
    instance_ids   = module.compute.instance_ids
    nat_gateway_ip = module.networking.nat_gateway_public_ip
  }
}