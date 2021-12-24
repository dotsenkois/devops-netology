data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "aws_ami_id" {
  value       = data.aws_ami.ubuntu.id
  description = "aws_ami_id"
}

output "public_ip" {
value = aws_instance.web.public_ip 
description = "public_ip"
}

output "subnet_id" {
value = aws_instance.web.subnet_id
description = "subnet_id"
}