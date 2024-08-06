# main.tf

provider "aws" {
  profile = "intern-profile"
  region  = "us-east-1"
}

module "security_group" {
  source = "./modules/security_group"
}

module "instance" {
  source           = "./modules/instance"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  security_group_id = module.security_group.security_group_id
}

