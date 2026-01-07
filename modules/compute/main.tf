# Compute Module: Two EC2 instances with Todo App

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

# EC2 Instance 1
resource "aws_instance" "app_1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_app_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y nodejs npm git

# Clone the Todo application from GitHub
git clone https://github.com/KofiAckah/Todo-App-3Tier.git /var/www/todo-app
cd /var/www/todo-app

# Install dependencies
npm install

# Set environment variables for the app
cat > /etc/environment <<ENVFILE
DB_TYPE=mysql
DB_HOST=${var.db_endpoint}
DB_USER=${var.db_username}
DB_PASS=${var.db_password}
DB_NAME=${var.db_name}
DB_PORT=3306
PORT=80
ENVFILE

# Create systemd service for the Todo app
cat > /etc/systemd/system/todo-app.service <<SVCFILE
[Unit]
Description=Todo App
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/www/todo-app
EnvironmentFile=/etc/environment
ExecStart=/usr/bin/node server.js
Restart=always

[Install]
WantedBy=multi-user.target
SVCFILE

systemctl daemon-reload
systemctl enable todo-app
systemctl start todo-app
EOF
  )

  tags = merge(
    {
      Name = "3tier-app-instance-1"
    },
    local.common_tags
  )
}

# EC2 Instance 2
resource "aws_instance" "app_2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_app_subnet_ids[1]
  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(<<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y nodejs npm git

# Clone the Todo application from GitHub
git clone https://github.com/KofiAckah/Todo-App-3Tier.git /var/www/todo-app
cd /var/www/todo-app

# Install dependencies
npm install

# Set environment variables for the app
cat > /etc/environment <<ENVFILE
DB_TYPE=mysql
DB_HOST=${var.db_endpoint}
DB_USER=${var.db_username}
DB_PASS=${var.db_password}
DB_NAME=${var.db_name}
DB_PORT=3306
PORT=80
ENVFILE

# Create systemd service for the Todo app
cat > /etc/systemd/system/todo-app.service <<SVCFILE
[Unit]
Description=Todo App
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/var/www/todo-app
EnvironmentFile=/etc/environment
ExecStart=/usr/bin/node server.js
Restart=always

[Install]
WantedBy=multi-user.target
SVCFILE

systemctl daemon-reload
systemctl enable todo-app
systemctl start todo-app
EOF
  )

  tags = merge(
    {
      Name = "3tier-app-instance-2"
    },
    local.common_tags
  )
}

# Attach instances to target group
resource "aws_lb_target_group_attachment" "app_1" {
  target_group_arn = var.target_group_arns[0]
  target_id        = aws_instance.app_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_2" {
  target_group_arn = var.target_group_arns[0]
  target_id        = aws_instance.app_2.id
  port             = 80
}
