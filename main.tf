// Creating a VPC (Virtual Private Cloud)
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr  // Specify the CIDR block for the VPC

  tags = {
    Name = "MainVPC"  // Tag for identification
  }
}

// Creating an internet gateway to provide internet access to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  // Attach the internet gateway to the VPC

  tags = {
    Name = "MainInternetGateway"  // Tag for identification
  }
}

// Creating a route table to define a route for internet access 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id  // Associate the route table with the VPC

  // Define a route to direct traffic to the internet gateway
  route {
    cidr_block = "0.0.0.0/0"  // This route applies to all IP addresses
    gateway_id = aws_internet_gateway.main.id  // Use the internet gateway for this route
  }

  tags = {
    Name = "PublicRouteTable"  // Tag for identification
  }
}

// Associating the route table with the public subnet of the VPC 
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id  // The public subnet to associate with
  route_table_id = aws_route_table.public_route_table.id  // The route table to associate
}

// Creating the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id  // Associate the subnet with the VPC
  cidr_block        = var.public_subnet_cidr  // Specify the CIDR block for the public subnet
  availability_zone = "${var.aws_region}a"  // Define the availability zone for the subnet
  map_public_ip_on_launch = true  // Automatically assign public IPs to instances launched in this subnet

  tags = {
    Name = "PublicSubnet"  // Tag for identification
  }
}

// Creating the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id  // Associate the subnet with the VPC
  cidr_block        = var.private_subnet_cidr  // Specify the CIDR block for the private subnet
  availability_zone = "${var.aws_region}a"  // Define the availability zone for the subnet

  tags = {
    Name = "PrivateSubnet"  // Tag for identification
  }
}

// Creating the security group with HTTP inbound rule and one outbound rule
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id  // Associate the security group with the VPC

  // Inbound rule to allow HTTP traffic
  ingress {
    from_port   = 80  // Allow traffic on port 80
    to_port     = 80  // Allow traffic on port 80
    protocol    = "tcp"  // Use TCP protocol
    cidr_blocks = ["0.0.0.0/0"]  // Allow traffic from all IP addresses
  }

  // Outbound rule to allow all outbound traffic
  egress {
    from_port   = 0  // Allow all ports
    to_port     = 0  // Allow all ports
    protocol    = "-1"  // Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  // Allow traffic to all IP addresses
  }

  tags = {
    Name = "ECS_Security_Group"  // Tag for identification
  }
}

// Creating an ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name  // Specify the name of the ECS cluster
}

// Creating a task definition for the Fargate task
resource "aws_ecs_task_definition" "fargate_task" {
  family                   = var.task_definition_family  // Specify the family name for the task definition
  requires_compatibilities = ["FARGATE"]  // Define compatibility with Fargate
  network_mode            = "awsvpc"  // Use awsvpc network mode for task
  cpu                     = "256"  // Specify the CPU units for the task
  memory                  = "512"  // Specify the memory for the task

  // Container definitions for the task
  container_definitions = jsonencode([
    {
      name         = "fargate-app"  // Name of the container
      image        = "public.ecr.aws/docker/library/httpd:latest"  // Container image to use
      portMappings = [
        {
          containerPort = 80  // Port the container listens on
          hostPort      = 80  // Port on the host to map to
          protocol      = "tcp"  // Protocol for the port mapping
        }
      ],
      essential     = true,  // Mark the container as essential
      entryPoint    = [
        "sh",  // Entry point for the container
        "-c"  // Execute the command provided
      ],
      command       = [
        "/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' > /usr/local/apache2/htdocs/index.html && httpd-foreground\""
      ]
    }
  ])
}

// Creating an ECS service for the Fargate task
resource "aws_ecs_service" "fargate_service" {
  name            = var.service_name  // Specify the name of the ECS service
  cluster         = aws_ecs_cluster.ecs_cluster.id  // Associate the service with the ECS cluster
  task_definition = aws_ecs_task_definition.fargate_task.arn  // Specify the task definition for the service
  desired_count   = 1  // Define the desired number of tasks to run
  launch_type     = "FARGATE"  // Specify the launch type for the service

  // Network configuration for the ECS service
  network_configuration {
    subnets          = [aws_subnet.public_subnet.id]  // Specify the subnets for the service
    security_groups  = [aws_security_group.ecs_sg.id]  // Associate the security group with the service
    assign_public_ip = true  // Assign public IPs to the tasks
  }
}
