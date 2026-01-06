# VPC Configuration
variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

# Security Group
variable "web_sg_id" {
  description = "Security group ID for ALB (Web Security Group)"
  type        = string
}

# Project Configuration
variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ALB Configuration
variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

# Target Group Configuration
variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

# Health Check Configuration
variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive health checks to be considered healthy"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks to be considered unhealthy"
  type        = number
  default     = 2
}

# Target Attachments (Optional)
variable "target_instance_ids" {
  description = "List of EC2 instance IDs to attach to target group (leave empty if using ASG)"
  type        = list(string)
  default     = []
}

# HTTPS Configuration (Optional)
# variable "certificate_arn" {
#   description = "ARN of SSL certificate for HTTPS listener"
#   type        = string
#   default     = ""
# }