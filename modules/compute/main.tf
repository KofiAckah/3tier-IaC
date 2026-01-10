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
set -e

# Update system
apt-get update -y
apt-get install -y nodejs npm git curl

# Create application directory
mkdir -p /var/www/todo-app
cd /var/www/todo-app

# Clone the Todo application
git clone https://github.com/KofiAckah/Todo-App-3Tier.git .
npm install

# Create .env file with correct variable names
cat > /var/www/todo-app/.env <<ENVFILE
DB_TYPE=mysql
DB_HOST=${var.db_endpoint}
DB_PORT=3306
DB_NAME=${var.db_name}
DB_USER=${var.db_username}
DB_PASSWORD=${var.db_password}
PORT=80
ENVFILE

# Install PM2 globally
npm install -g pm2

# Set permissions
chown -R ubuntu:ubuntu /var/www/todo-app

# Start application with PM2
cd /var/www/todo-app
pm2 start server.js --name todo-app
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

# Enable port 80 for non-root user
setcap 'cap_net_bind_service=+ep' $(which node)

echo "Application deployed successfully" > /var/log/user-data.log
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
set -e

# Update system
apt-get update -y
apt-get install -y nodejs npm git curl

# Create application directory
mkdir -p /var/www/todo-app
cd /var/www/todo-app

# Clone the Todo application
git clone https://github.com/KofiAckah/Todo-App-3Tier.git .
npm install

# Create .env file with correct variable names
cat > /var/www/todo-app/.env <<ENVFILE
DB_TYPE=mysql
DB_HOST=${var.db_endpoint}
DB_PORT=3306
DB_NAME=${var.db_name}
DB_USER=${var.db_username}
DB_PASSWORD=${var.db_password}
PORT=80
ENVFILE

# Install PM2 globally
npm install -g pm2

# Set permissions
chown -R ubuntu:ubuntu /var/www/todo-app

# Start application with PM2
cd /var/www/todo-app
pm2 start server.js --name todo-app
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

# Enable port 80 for non-root user
setcap 'cap_net_bind_service=+ep' $(which node)

echo "Application deployed successfully" > /var/log/user-data.log
EOF
  )

  tags = merge(
    {
      Name = "3tier-app-instance-2"
    },
    local.common_tags
  )
}

# Attach Instance 1 to Target Group
resource "aws_lb_target_group_attachment" "app_1" {
  target_group_arn = var.target_group_arns[0]
  target_id        = aws_instance.app_1.id
  port             = 80
}

# Attach Instance 2 to Target Group
resource "aws_lb_target_group_attachment" "app_2" {
  target_group_arn = var.target_group_arns[0]
  target_id        = aws_instance.app_2.id
  port             = 80
}