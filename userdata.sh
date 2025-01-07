#!/bin/bash
yum update -y
curl -fsSL https://rpm.nodesource.com/setup_23.x | bash -
yum install -y nodejs git
mkdir -p /home/ec2-user/app && cd /home/ec2-user/app
git clone https://github.com/lalidiaz/terraform-aws-secrets-manager.git .
npm install
npm run start
