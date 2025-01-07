resource "aws_secretsmanager_secret" "secret_terraform_challenge" {
  name = "secret_terraform_challenge"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_terraform_challenge_version" {
  secret_id     = aws_secretsmanager_secret.secret_terraform_challenge.id
  secret_string = "secret"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "terraform_challenge_instance_profile"
  role = aws_iam_role.ec2_secrets_role.name
}

resource "aws_iam_role" "ec2_secrets_role" {
  name = "secretsrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name    = "EC2SecretsManagerRole"
    Purpose = "Allow EC2 to access Secrets Manager"
  }
}

resource "aws_iam_policy" "my_secrets_policy" {
  name   = "my_secrets_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.my_secrets_policy.json
}

resource "aws_iam_role_policy_attachment" "secrets_policy" {
  role       = aws_iam_role.ec2_secrets_role.name
  policy_arn = aws_iam_policy.my_secrets_policy.arn
}

resource "aws_security_group" "aws_terraform_challenge_security_group" {
  name        = "aws_terraform_challenge_security_group"
  vpc_id      = data.aws_vpc.default_vpc.id

  tags = {
    Name = "aws_terraform_challenge_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.aws_terraform_challenge_security_group.id
  cidr_ipv4         = "YOUR_IP_HERE"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_my_ip" {
  security_group_id = aws_security_group.aws_terraform_challenge_security_group.id
  cidr_ipv4         = "YOUR_IP_HERE"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_3000_traffic_from_my_ip" {
  security_group_id = aws_security_group.aws_terraform_challenge_security_group.id
  cidr_ipv4         = "YOUR_IP_HERE"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress_rule" {
  security_group_id = aws_security_group.aws_terraform_challenge_security_group.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.linux_ami.id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  key_name = "aws-terraform-challenge"
  security_groups = [ aws_security_group.aws_terraform_challenge_security_group.name ]
  user_data = file("userdata.sh")

  tags = {
    Name = "aws_terraform_challenge"
  }
}