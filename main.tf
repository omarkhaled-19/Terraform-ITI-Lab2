provider "aws" {
    region = var.aws_region
}

#Create VPC 10.0.0.0/16
resource "aws_vpc" "lab2-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = var.vpc_tags
}

#Create Subnets
resource "aws_subnet" "my-pub-subnet" {
    vpc_id = aws_vpc.lab2-vpc.id
    # count = var.public_subnet_count
    availability_zone = "us-east-1a"
    cidr_block = var.public_subnet_cidr_block
    map_public_ip_on_launch = true
    tags = var.public_subnet_tags
}
resource "aws_subnet" "my-pvt-subnet" {
  vpc_id = aws_vpc.lab2-vpc.id
#   count = var.private_subnet_count
  cidr_block = var.private_subnet_cidr_block
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = var.private_subnet_tags
}

#Create Internet Gateway
resource "aws_internet_gateway" "lab2-igw" {
    vpc_id = aws_vpc.lab2-vpc.id
    tags = var.igw-tags
}

#Create an Elastic IP address (EIP) to assign to NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = var.eip_tags
}
#Create NAT Gateway
resource "aws_nat_gateway" "lab2-ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.my-pub-subnet.id

  depends_on = [ aws_internet_gateway.lab2-igw ]
}

#Create Route Table for routing the public subnet to internet gateway
resource "aws_route_table" "pub-sub-rt" {
  vpc_id = aws_vpc.lab2-vpc.id
  route {
    cidr_block = var.public_subnet_rt_ipv4
    gateway_id = aws_internet_gateway.lab2-igw.id
  }
  route {
    ipv6_cidr_block = var.public_subnet_rt_ipv6
    gateway_id = aws_internet_gateway.lab2-igw.id
  }
  depends_on = [ aws_internet_gateway.lab2-igw ]
  tags = var.public_subnet_rt_tags
}

#Associate the Route table with the Subnet
resource "aws_route_table_association" "rt-public-subnet-associating" {
  route_table_id = aws_route_table.pub-sub-rt.id
  subnet_id = aws_subnet.my-pub-subnet.id
}

#Create Route Table for routing the private subnet to NAT gateway
resource "aws_route_table" "pvt-sub-rt" {
    vpc_id = aws_vpc.lab2-vpc.id
    route {
        cidr_block = var.private_subnet_rt_ipv4
        nat_gateway_id = aws_nat_gateway.lab2-ngw.id
    }
    depends_on = [ aws_nat_gateway.lab2-ngw ]
    tags = var.private_subnet_rt_tags
}
#Associate the Route table with the Subnet
resource "aws_route_table_association" "rt-private-subnet-associating" {
  route_table_id = aws_route_table.pvt-sub-rt.id
  subnet_id = aws_subnet.my-pvt-subnet.id
}


#Create a Security group. To allow public access rule
resource "aws_security_group" "lab2-sg-public" {
  name = var.sg-public-name
  vpc_id = aws_vpc.lab2-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow-http" {
    security_group_id = aws_security_group.lab2-sg-public.id
    ip_protocol = var.sg-public-ingress-ip_protocol
    from_port = var.sg-public-ingress-ip_port["http"]
    to_port = var.sg-public-ingress-ip_port["http"]
    cidr_ipv4 = var.sg-public-ingress-cidr-source
}

resource "aws_vpc_security_group_ingress_rule" "allow-https" {
    security_group_id = aws_security_group.lab2-sg-public.id
    ip_protocol = var.sg-public-ingress-ip_protocol
    from_port = var.sg-public-ingress-ip_port["https"]
    to_port = var.sg-public-ingress-ip_port["https"]
    cidr_ipv4 = var.sg-public-ingress-cidr-source
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
    security_group_id = aws_security_group.lab2-sg-public.id
    ip_protocol = var.sg-public-ingress-ip_protocol
    from_port = var.sg-public-ingress-ip_port["ssh"]
    to_port = var.sg-public-ingress-ip_port["ssh"]
    cidr_ipv4 = var.sg-public-ingress-cidr-source
}

resource "aws_vpc_security_group_egress_rule" "public-egress-all" {
  security_group_id = aws_security_group.lab2-sg-public.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

#Create a Security group. For Private Instance
resource "aws_security_group" "lab2-sg-private" {
  vpc_id = aws_vpc.lab2-vpc.id
  name = var.sg-private-name
}
resource "aws_vpc_security_group_ingress_rule" "allow-http-private" {
    
    security_group_id = aws_security_group.lab2-sg-private.id
    ip_protocol = var.sg-private-ingress-ip_protocol
    from_port = var.sg-private-ingress-ip_port["http"]
    to_port = var.sg-private-ingress-ip_port["http"]
    cidr_ipv4 = aws_subnet.my-pub-subnet.cidr_block
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh-private" {
    security_group_id = aws_security_group.lab2-sg-private.id
    ip_protocol = var.sg-private-ingress-ip_protocol
    from_port = var.sg-private-ingress-ip_port["ssh"]
    to_port = var.sg-private-ingress-ip_port["ssh"]
    cidr_ipv4 = var.sg-public-ingress-cidr-source
}

resource "aws_vpc_security_group_egress_rule" "private-egress-all" {
  security_group_id = aws_security_group.lab2-sg-private.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

data "aws_ami" "amazon_linux2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
#Create Key pair for ec2 access
resource "aws_key_pair" "lab2-key" {
  key_name   = var.ssh-key-name
  public_key = file(var.ssh-key-file)
}
#Create the Public EC2 instance


resource "aws_instance" "lab2-public-webserver" {
#    ami = "ami-08982f1c5bf93d976"
    ami = data.aws_ami.amazon_linux2023.id
    instance_type = var.public-ec2-instance-type
    vpc_security_group_ids = [aws_security_group.lab2-sg-public.id]
    subnet_id = aws_subnet.my-pub-subnet.id
    associate_public_ip_address = true  
    key_name = aws_key_pair.lab2-key.key_name
    user_data = var.public-ec2-user-data
    tags = var.ec2-public-tags

}

#Create the Private EC2 instance

resource "aws_instance" "lab2-private-webserver" {
    ami = data.aws_ami.amazon_linux2023.id
    instance_type = var.private-ec2-instance-type
    vpc_security_group_ids = [aws_security_group.lab2-sg-private.id]
    subnet_id = aws_subnet.my-pvt-subnet.id
    associate_public_ip_address = false
    key_name = aws_key_pair.lab2-key.key_name
    user_data = var.private-ec2-user-data
    tags =var.ec2-private-tags

}