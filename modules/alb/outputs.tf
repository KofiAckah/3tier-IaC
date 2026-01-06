# ALB Outputs
output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

# Target Group Outputs
output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "target_group_id" {
  description = "ID of the target group"
  value       = aws_lb_target_group.main.id
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.main.name
}

# Listener Outputs
output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

# HTTPS Listener Output (Uncomment if using HTTPS)
# output "https_listener_arn" {
#   description = "ARN of the HTTPS listener"
#   value       = aws_lb_listener.https.arn
# }

# Complete ALB Information
output "alb_info" {
  description = "Complete ALB information"
  value = {
    alb_dns_name      = aws_lb.main.dns_name
    alb_arn           = aws_lb.main.arn
    target_group_arn  = aws_lb_target_group.main.arn
    target_group_name = aws_lb_target_group.main.name
  }
}