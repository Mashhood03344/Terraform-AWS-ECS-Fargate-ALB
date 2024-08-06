output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.instance.public_ip
}
