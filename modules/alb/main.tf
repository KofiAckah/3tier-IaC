# ### Module 3: ALB
# Must include:
# - ALB
# - Listener (HTTP 80 or HTTPS 443)
# - Target Group
# - Target attachments
# - Reference Web Security Group

# Outputs:
# - ALB DNS name
# - Target group ARN

# Local variables for consistent tagging
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# 1. Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = merge(
    local.common_tags,
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-alb"
      Tier = "Presentation"
    }
  )
}

# 2. Target Group
resource "aws_lb_target_group" "main" {
  name     = "${var.project_name}-${var.environment}-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  # Health check configuration
  health_check {
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    protocol            = var.target_group_protocol
    matcher             = "200"
  }

  # Deregistration delay
  deregistration_delay = 30

  # Stickiness (optional)
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-tg"
    }
  )
}

# 3. HTTP Listener (Port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-http-listener"
    }
  )
}

# 4. HTTPS Listener (Port 443) - Optional
# Uncomment this section if you have an SSL certificate

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.main.arn
#   }
#
#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${var.project_name}-${var.environment}-https-listener"
#     }
#   )
# }


# 5. Target Group Attachments (Optional)
# This is for manually attaching EC2 instances
# If using ASG, the ASG will automatically register targets

resource "aws_lb_target_group_attachment" "instances" {
  count            = length(var.target_instance_ids)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = var.target_instance_ids[count.index]
  port             = var.target_group_port
}