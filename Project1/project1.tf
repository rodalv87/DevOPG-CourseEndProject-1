provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAVDNOHJXRZXK5UYM5"
  secret_key = "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"
}

resource "aws_security_group" "sec_project1" {
  name        = "sec_project1"
  description = "Allow inbound SSH"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
ingress {
     description = "HTTP"
     from_port   = 8080
     to_port     = 8080
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
     egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
}


resource "aws_instance" "Project1" {
  ami           = "ami-06a0cd9728546d178"
  instance_type = "t2.micro"

  tags = {
    Name = "Project1"
  }
   key_name = "key_project1"
   user_data = <<-EOF
      #!/bin/bash
        sudo yum install python3 -y
        sudo amazon-linux-extras install java-openjdk11 -y
  	   sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
        sudo yum install jenkins -y
        sudo systemctl start jenkins
   EOF
}

resource "aws_network_interface_sg_attachment" "sg_attachment1" {

security_group_id = aws_security_group.sec_project1.id

network_interface_id = aws_instance.Project1.primary_network_interface_id

}
