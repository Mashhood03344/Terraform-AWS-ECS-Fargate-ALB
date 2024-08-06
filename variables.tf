# variables.tf

variable "instance_type" {
  description = "The instance type to use"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The Amazon Machine Image ID to use"
  default     = "ami-04a81a99f5ec58529"  # Verify this AMI ID
}

