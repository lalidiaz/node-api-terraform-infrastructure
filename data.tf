data "aws_kms_key" "by_alias" {
  key_id = "alias/aws/secretsmanager"
}


data "aws_iam_policy_document" "my_secrets_policy" {
 statement {
  
    actions = [
      "kms:DescribeKey",
      "kms:ListAliases",
      "kms:ListKeys"
    ]

    resources = [
      data.aws_kms_key.by_alias.arn,
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds"
    ]

    resources = [
        join("", [aws_secretsmanager_secret.secret_terraform_challenge.id, "*"])
       
    ]
  }
}

data "aws_ami" "linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
}

data "aws_vpc" "default_vpc"{
  default = true
}