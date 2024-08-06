variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "1.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  default     = "1.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  default     = "1.0.2.0/24"
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  default     = "my-ecs-cluster"
}

variable "service_name" {
  description = "The name of the ECS service"
  default     = "my-ecs-service"
}

variable "task_definition_family" {
  description = "The family of the ECS task definition"
  default     = "sample-fargate"
}
