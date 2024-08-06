# AWS Infrastructure Setup Documentation

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Variables](#variables)
4. [Resources Created](#Resources-Created)
5. [Usage](#usage)
6. [Cleanup](#cleanup)

## Overview

This Terraform configuration defines an AWS infrastructure setup that includes a Virtual Private Cloud (VPC), subnets, security groups, an ECS (Elastic Container Service) cluster, a Fargate task definition,  					and an ECS service This setup enables hosting a html web page on AWS.

## Prerequisites
 - Terraform installed on your local machine.
 - An AWS account with appropriate permissions to create the specified resources.


## Variables

A configured variables.tf file containing values for the following variables:
- vpc_cidr: The CIDR block for the VPC.
- public_subnet_cidr: The CIDR block for the public subnet.
- private_subnet_cidr: The CIDR block for the private subnet.
- aws_region: The AWS region where the resources will be created.
- cluster_name: The name of the ECS cluster.
- task_definition_family: The family name for the ECS task definition.
- service_name: The name of the ECS service.


## Resources Created

1. **VPC**:

 - Resource Type: aws_vpc
 - Description: Creates a VPC to host the resources.

2. **Internet Gateway**:

 - Resource Type: aws_internet_gateway
 - Description: Creates an internet gateway to provide internet access to the VPC.

3. **Route Table**:

 - Resource Type: aws_route_table
 - Description: Creates a route table to direct traffic from the VPC to the internet via the internet gateway.
 - Route: Allows outbound traffic to all IP addresses (0.0.0.0/0).
 
4. **Route Table Association**:

 - Resource Type: aws_route_table_association
 - Description: Associates the public route table with the public subnet.

5. **Public Subnet**:

 - Resource Type: aws_subnet
 - Description: Creates a public subnet within the VPC.
 - Properties: Automatically assigns public IPs to instances launched in this subnet.
 
6. **Private Subnet**:

 - Resource Type: aws_subnet
 - Description: Creates a private subnet within the VPC.

7. **Security Group**:

 - Resource Type: aws_security_group
 - Description: Creates a security group that allows inbound HTTP traffic (port 80) and all outbound traffic.

9. **ECS Cluster**:

 - Resource Type: aws_ecs_cluster
 - Description: Creates an ECS cluster for managing containerized applications.
 
10. **ECS Task Definition**:

 - Resource Type: aws_ecs_task_definition
 - Description: Defines a Fargate task with specific container configurations.
 - Properties:
 
	- Family: Defined by the variable task_definition_family.
	- Network Mode: awsvpc.
	- CPU: 256 units.
	- Memory: 512 MiB.
	- Container Definition: Defines a single container running an HTTP server with a sample HTML page.

11. **ECS Service**:
	
 - Resource Type: aws_ecs_service
 - Description: Creates a service for the Fargate task definition.
 - Properties:
 	- Desired Count: 1 (indicates one task should be running).
	- Launch Type: FARGATE.
	- Network Configuration: Uses the public subnet and the defined security group. Assigns public IPs to the tasks.
## Usage

1. **Clone the Repository: Clone the repository containing the Terraform configuration.**
2. **Navigate to the Directory: Open your terminal and navigate to the directory containing the Terraform files.**
3. **Initialize Terraform: Run the command:**
	
 	```bash
 	terraform init
 	```
 	
4. **Plan the Deployment: Check what resources will be created by running:**
	```bash
	terraform plan
	```
	
5. **Apply the Configuration: Deploy the infrastructure by running:**
	```bash
	terraform apply
	```
	
6. **Verify Resources: Once applied, verify the created resources in the AWS Management Console.**

	Notes

	- Ensure your AWS credentials are configured properly for Terraform to authenticate and create resources in your account.
	- Review and update the security group rules as needed based on your application requirements.

## Cleanup

To remove all the created resources, run:

	terraform destroy
