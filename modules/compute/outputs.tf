# Compute Module: outputs.tf

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = [aws_instance.app_1.id, aws_instance.app_2.id]
}

output "instance_1_id" {
  description = "ID of instance 1"
  value       = aws_instance.app_1.id
}

output "instance_2_id" {
  description = "ID of instance 2"
  value       = aws_instance.app_2.id
}
