# AWS Node Secret Manager Demo

This project demonstrates the deployment of my [NodeJS application](https://github.com/lalidiaz/terraform-aws-secrets-manager) that retrieves and displays secrets from **AWS Secrets Manager**. The infrastructure is provisioned using **Terraform**, showcasing Infrastructure as Code (IaC) capabilities with AWS services.

## Project Overview

This project deploys:
- A Node application that retrieves secrets from AWS Secrets Manager
- Required AWS infrastructure including EC2, IAM roles, and security groups
- Proper security configurations and access controls

## Architecture

The infrastructure includes:
- EC2 instance running the Node application
- AWS Secrets Manager for secure secret storage
- IAM roles and policies for EC2-Secrets Manager interaction
- Security groups with specific ingress/egress rules
- Instance profile for EC2-IAM integration

## Prerequisites

Before running this project, ensure you have:

1. An AWS Account
2. AWS CLI installed and configured with appropriate credentials
3. Terraform installed on your local machine
4. Your IPv4 address (to configure security group rules)

## Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/lalidiaz/terraform-aws-secrets-manager
cd terraform-aws-secrets-manager
```

2. Update security group configuration:
   - Locate "YOUR_IP_HERE" in the security group rules
   - Replace it with your IPv4 address

3. Initialize Terraform:
```bash
terraform init
```

4. Review the infrastructure plan:
```bash
terraform plan
```

5. Apply the infrastructure:
```bash
terraform apply
```

## Infrastructure Components

The Terraform configuration creates:

1. **Secrets Manager**
   - Creates and manages secrets

2. **IAM Resources**
   - IAM Role for EC2
   - IAM Policy for Secrets Manager access
   - IAM Instance Profile
   - IAM Role-Policy attachment

3. **Security Groups**
   - Ingress Rules:
     - HTTP traffic (Port 80)
     - Application traffic (Port 3000) from specified IP
   - Egress Rules:
     - All outbound traffic

4. **EC2 Instance**
   - Configured with user data script
   - Associated with IAM instance profile
   - Protected by security groups

## Outputs

The project provides the following outputs:
- AMI ID of the created EC2 instance
- Public IP address of the EC2 instance

## Accessing the Application

Once deployed, the application can be accessed at:
```
http://<aws_instance_public_ip>:3000
```

## Security Considerations

- The security group only allows traffic from your specified IP address
- Secrets are managed securely through AWS Secrets Manager
- IAM roles follow the principle of least privilege

## Cleanup

To avoid incurring charges, remember to destroy the infrastructure when not in use:
```bash
terraform destroy
```

