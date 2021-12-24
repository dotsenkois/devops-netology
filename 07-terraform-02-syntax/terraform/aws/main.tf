provider "aws" {
region = "eu-north-1"
shared_credentials_file = "/home/dotsenkois/some_secret_data/aws_keys/dotsenkoiskey.csv"
profile                 = "dotsenkois"
}

# Find the latest available AMI that is tagged with Component = web
data "aws_ami" "ubuntu" {
most_recent = true
owners = ["099720109477"]
filter {
name = "name"
values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20211129"]
}
}


resource "aws_instance" "web" {
ami =  data.aws_ami.ubuntu.id
instance_type = "t3.micro"
cpu_core_count = "2"
cpu_threads_per_core = "1"
tags = {
Name = "HelloWorld"
Autor = "dotsenkois"
}
ebs_block_device {
        delete_on_termination = "true"
        device_name           = "main"
        encrypted             = "false"
        volume_size           = "2"
        volume_type           = "gp2"
        }
}

