provider "aws" {
  region = "eu-west-1"
}

# Create a VPC
# Resources are the references that exist inside AWS

# resource "aws_vpc" "app_vpc" {
#   cidr_block  = "10.0.0.0/16"
#   tags = {
#       name    = "Aymz_eng54_app_vpc"
#   }
# }

# Use the DevOps VPC ID
# Create a new subnet
# Move our instance into the new subnet
resource "aws_subnet" "app_subnet" {
    vpc_id                      = "vpc-07e47e9d90d2076da"
    cidr_block                  = "172.31.88.0/24"
    availability_zone           = "eu-west-1a"
    tags = {
      Name                      = "Aymz_App_Public_Subnet"
    }
}

# Creating a security group, linking it with VPC and attaching it to our instance
resource "aws_security_group" "app_security" {
  name        = "Aymz_security_Group_App"
  description = "Security Group port 80 traffic"
  vpc_id      = "vpc-07e47e9d90d2076da"

  ingress {
    description = "inbound rules"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Default outbound rules for SG is it lets everything out automaticly
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Aymz_Eng54_App_SG"
  }
}

# Launching an Instance
resource "aws_instance" "app_instance" {
    ami                         = "ami-040bb941f8d94b312"
    instance_type               = "t2.micro"
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.app_subnet.id
    vpc_security_group_ids      = [aws_security_group.app_security.id]
    tags = {
        Name                    = "Aymz_Eng54_App"
    }
}
