#VPC Values
vpc_cidr_block = "10.0.0.0/16"
vpc_tags = {
  "Name" = "Lab2-VPC"
}

#Subnet Values
#----Public Subnet Values-------
public_subnet_count = 1
public_subnet_cidr_block =  "10.0.0.0/24" 
public_subnet_tags =  {
  "Name" = "Lab2-Public-Subnet-1"
}
public_subnet_rt_ipv4 = "0.0.0.0/0"
public_subnet_rt_ipv6 = "::/0"
public_subnet_rt_tags = {
  "Name" = "pub_rt"
}
#----Private Subnet Values------
private_subnet_count = 1
private_subnet_cidr_block = "10.0.1.0/24"
private_subnet_tags = {
  "Name" = "Lab2-Private-Subnet-1"
}

private_subnet_rt_ipv4 = "0.0.0.0/0"
private_subnet_rt_tags = {
  "Name" = "pvt-rt"
}

#Elastic IP tag value
eip_tags = {
  "Name" = "public-nat-eip"
}

igw-tags = {
  "Name" = "lab2-igw"
}

#Security Groups: Public
sg-public-name = "allow-public-tcp"
sg-public-ingress-ip_protocol = "tcp"
sg-public-ingress-ip_port = {
  "http"  = 80
  "https" = 443
  "ssh"   = 22
}
sg-public-ingress-cidr-source = "0.0.0.0/0"


#Security Group: Private
sg-private-name = "allow-private-tcp"
sg-private-ingress-ip_protocol = "tcp"
sg-private-ingress-ip_port = {
  "http"  = 80
  "https" = 443
  "ssh"   = 22
}
#Key Pairs
ssh-key-name = "lab2-key"
ssh-key-file = "~/.ssh/lab2-key.pub"

private-ec2-user-data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello from Private EC2 and Subnet in Terraform!" > /var/www/html/index.html
              EOF
public-ec2-user-data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello from Public EC2 and Subnet in Terraform!" > /var/www/html/index.html
              EOF
ec2-private-tags = {
  "Name" = "lab2-ec2-private"
}
ec2-public-tags = {
  "Name" = "lab2-ec2-public"
}

private-ec2-instance-type = "t3.micro"
public-ec2-instance-type = "t3.micro"