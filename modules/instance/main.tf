# modules/instance/main.tf

variable "ami_id" {
  description = "The Amazon Machine Image ID to use"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "deployer-key"  # Ensure this key pair exists in AWS

  vpc_security_group_ids = [var.security_group_id]

  user_data = <<-EOF
               #!/bin/bash
              sudo apt update -y
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "Terraform-EC2-NGINX"
  }
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

# echo "Hello World" | sudo tee /usr/share/nginx/html/index.html

#             sudo chmod 644 /usr/share/nginx/html/index.html
#             sudo chown www-data:www-data /usr/share/nginx/html/index.html

