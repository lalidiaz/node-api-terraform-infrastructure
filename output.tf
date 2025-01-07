output "aws_instance_ami" {
    value = aws_instance.app_server.ami 
}

output "aws_instance_public_ip" {
  value = aws_instance.app_server.public_ip
}
