terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAVH2BZOIJC4IRN5XC"
  secret_key = "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"
}
resource "aws_instance" "ec2-vm" {
  ami                    = "ami-02396cdd13e9a1257"
  subnet_id              = "subnet-008f139b69a07aca3"
  vpc_security_group_ids = ["sg-020bac3d258db1f9f"]
  key_name               = "morpheus-15-LE6R8S"
  instance_type          = "t2.micro"
  user_data              = <<-EOF
    #!/bin/bash

    # Add a new user
    adduser aung

    # Set a password for the new user
    echo "aung:P@ssw0rd" | chpasswd

    # Add the new user to the sudo group (if required)
    usermod -aG wheel aung
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    service sshd restart
  EOF
  tags = {
    Name = "morpheus-ec2-tf-instance"
  }
}
resource "aws_eip" "eip" {
  instance = aws_instance.ec2-vm.id
  domain   = "vpc"
}
