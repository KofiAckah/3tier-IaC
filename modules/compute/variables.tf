# List of private app subnet IDs for EC2
variable "private_app_subnet_ids" {
  description = "List of private app subnet IDs for EC2 instances"
  type        = list(string)
}

# Security Group ID
variable "security_group_id" {
  description = "Security Group ID to associate with the instances"
  type        = string
}

# Target group ARNs for ALB attachment
variable "target_group_arns" {
  description = "List of target group ARNs to attach instances to"
  type        = list(string)
  default     = []
}

# RDS connection variables
variable "db_endpoint" {
  description = "RDS endpoint for database connection"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "tododb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = ""
}

# Tagging variables
variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project tag"
  type        = string
  default     = "3tier-iac"
}

variable "owner" {
  description = "Owner tag"
  type        = string
  default     = "your_name"
}
