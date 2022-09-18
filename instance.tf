resource "aws_instance" "artifactory-s3" {
  ami                    = "ami-0b55fc9b052b03618"
  instance_type          = "c3.xlarge"
  vpc_security_group_ids = [aws_security_group.aws-ec2.id]
  #   vpc_id                      = "vpc-03ed34629d50653ca"
  associate_public_ip_address = true
  #  subnet_id                   = aws_subnet.vpc.id
  key_name             = aws_key_pair.securekey.id
  iam_instance_profile = aws_iam_instance_profile.cicd.id
  user_data            = <<-EOF
#! /bin/bash
yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum install git -y
git clone git@github.com:rajkumargit12/mahammad.git

wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum upgrade -y
amazon-linux-extras install java-openjdk11 -y
yum install jenkins -y
systemctl start jenkins
systemctl enable jenkins
systemctl status jenkins
  EOF

  tags = {
    Name      = "artifactory"
    terraform = "true"
  }
}
resource "aws_instance" "apacherun" {
  ami                    = "ami-0b55fc9b052b03618"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.aws-ec2.id]
  #   vpc_id                      = "vpc-03ed34629d50653ca"
  associate_public_ip_address = true
  #   subnet_id                   = aws_subnet.vpc.id
  key_name  = aws_key_pair.securekey.id
  user_data = <<-EOF
  #!/bin/bash
   yum install httpd -y
   yum update -y
   systemctl start httpd
   sytemctl enable httpd
   systemctl status httpd
    EOF

  tags = {
    Name      = "apacherun"
    terraform = "true"
  }
}




