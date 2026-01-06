# Web Security Group Outputs
output "web_sg_id" {
  description = "ID of the Web security group"
  value       = aws_security_group.web_sg.id
}

output "web_sg_name" {
  description = "Name of the Web security group"
  value       = aws_security_group.web_sg.name
}

# App Security Group Outputs
output "app_sg_id" {
  description = "ID of the App security group"
  value       = aws_security_group.app_sg.id
}

output "app_sg_name" {
  description = "Name of the App security group"
  value       = aws_security_group.app_sg.name
}

# DB Security Group Outputs
output "db_sg_id" {
  description = "ID of the DB security group"
  value       = aws_security_group.db_sg.id
}

output "db_sg_name" {
  description = "Name of the DB security group"
  value       = aws_security_group.db_sg.name
}

# All Security Group IDs
output "all_sg_ids" {
  description = "Map of all security group IDs"
  value = {
    web = aws_security_group.web_sg.id
    app = aws_security_group.app_sg.id
    db  = aws_security_group.db_sg.id
  }
}