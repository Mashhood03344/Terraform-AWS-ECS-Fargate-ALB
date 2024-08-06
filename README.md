# Terraform AWS EC2 Instance with NGINX

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Variables](#variables)
4. [Terraform Configuration](#terraform-configuration)
5. [Usage](#usage)
6. [Accessing the NGINX Server](#accessing-the-nginx-server)
7. [Configuration for Custom Website](#configuration-for-custom-website)
8. [Create a Symlink for NGINX Configuration](#create-a-symlink-for-nginx-configuration)
9. [Cleanup](#cleanup)
10. [License](#license)

## Overview

This documentation provides instructions for provisioning an AWS EC2 instance using Terraform. The instance will run an NGINX web server and allow HTTP and SSH traffic.

## Prerequisites

Before using this Terraform configuration, ensure you have the following:
- Terraform installed on your local machine.
- An AWS account with permissions to create EC2 instances and security groups.
- AWS CLI configured with a profile that has access to your AWS account.
- An existing key pair in the specified AWS region for SSH access (replace `deployer-key` with your key pair name).

## Variables

The following variables must be defined in a `variables.tf` file or passed during execution:
- `ami_id`: The ID of the Amazon Machine Image (AMI) to use.
- `instance_type`: The type of EC2 instance to create (e.g., `t2.micro`).

## Terraform Configuration

The main Terraform configuration is located in the `main.tf` file, which includes:
- A provider block for AWS.
- A security group that allows SSH (port 22) and HTTP (port 80) traffic.
- An EC2 instance resource configured with user data to install and run NGINX.

## Usage

To deploy the EC2 instance, follow these steps:

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/Mashhood03344/Terraform-AWS-EC2-Instance-with-NGINX.git
    cd your-repo-name
    ```

2. **Initialize Terraform**:

    ```bash
    terraform init
    ```

4. **Validate the Configuration**:
    ```bash
    terraform validate
    ```

5. **Plan the Deployment**:

    ```bash
    terraform plan
    ```

6. **Apply the Configuration**:
7. 
    ```bash
    terraform apply
    ```
    
   Confirm the changes by typing `yes` when prompted.
   

## Configuration for Custom Website

To host your custom website, place your `index.html` file at the location `/var/www/html`. Below is an example of a simple HTML file:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World</title>
</head>
<body>
    <h1>Hello World</h1>
</body>
</html>
```

Additionally, you can create a configuration file for your website. Create a file named website.conf in the location /etc/nginx/sites-available with the following configuration:

```nginx
server {
    listen 80;
    listen [::]:80;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

## Create a Symlink for NGINX Configuration
To enable your new site configuration, create a symlink between the sites-available and sites-enabled directories with the following command:

```bash
sudo ln -s /etc/nginx/sites-available/website.conf /etc/nginx/sites-enabled/
```

After creating the symlink, reload NGINX to apply the changes:

```bash
sudo systemctl reload nginx
```

## Accessing the NGINX Server

Once the instance is running, access the NGINX web server by navigating to the public IP address of the instance in a web browser:

```bash
http://<instance-public-ip>
```

You should see a "Hello World" message displayed.


## Cleanup
To destroy the resources created by Terraform, run:

```bash
terraform destroy
```

Confirm the destruction by typing yes when prompted.
