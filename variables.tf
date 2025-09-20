#General Settings
variable "aws_region" {
  type = string
  description = "The regions deploying the services in"
  default = "us-east-1"
}

#VPC variables
variable "vpc_cidr_block" {
  type = string
  description = "The VPC cidr block"
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
    type = map(string)
    description = "VPC resource tags"
    default = {
      "Name" = "Lab-VPC"
    }
}

#Internet Gateway Tags
variable "igw-tags" {
  type = map(string)
  description = "igw tags"
}
#Subnets variables
#-----Public Subnet-----
variable "public_subnet_count" {
    type = number
    description = "number of public subnets to create"
    default = 2
}

variable "public_subnet_cidr_block" {
    type = string
    description = "List of Subnets to use"
}

variable "public_subnet_tags" {
  type = map(string)
  description = "The tags that will be used tag the subnets"
}

#---------Public Subnet Route Table----
variable "public_subnet_rt_ipv4" {
  type = string
  description = "The public subnet route table ipv4 route"
}
variable "public_subnet_rt_ipv6" {
  type = string
  description = "The public subnet route table ipv6 route"
}
variable "public_subnet_rt_tags" {
  type = map(string)
  description = "pub subnet route tags"
}
#-----Private Subnet-----
variable "private_subnet_count" {
    type = number
    description = "number of private subnets to create"
    default = 2
}
variable "private_subnet_cidr_block" {
    type = string
    description = "List of Subnets to use"
}

variable "private_subnet_tags" {
  type = map(string)
  description = "The tags that will be used tag the subnets"
}
#---------Private Subnet Route Table----
variable "private_subnet_rt_ipv4" {
  type = string
  description = "The private subnet route table route"
}
variable "private_subnet_rt_tags" {
  type = map(string)
  description = "private subnet route tags"
}


#Elastic IP Tags
variable "eip_tags" {
  type = map(string)
  description = "Elastic Ip tag variables"
}

#Security Group name for public instance 
variable "sg-public-name" {
  type = string
  description = "Name of the SG for allowing public internet"
}
variable "sg-public-ingress-ip_protocol" {
  type = string
  description = "IP protocol of the public ingress sg"
}
variable "sg-public-ingress-ip_port" {
  type = map(number)
  description = "Port numnbers of the public ip ingress sg"
}
variable "sg-public-ingress-cidr-source" {
    type = string
    description = "source range of ipv4 values"
  
}

#Security Group name for private instance
variable "sg-private-name" {
  type = string
  description = "Name of SG for private instance"
}
variable "sg-private-ingress-ip_protocol" {
  type = string
  description = "IP protocol of the private ingress sg"
}
variable "sg-private-ingress-ip_port" {
  type = map(number)
  description = "Port numnbers of the private ip ingress sg"
}

variable "ssh-key-name" {
  type = string
  description = "Name of the ssh key"
}
variable "ssh-key-file" {
  type = string
  description = "file path to the key pair"
}

variable "public-ec2-instance-type" {
  type = string
  description = "MAchine type of Public EC2 instance"
}
variable "private-ec2-instance-type" {
  type = string
  description = "Machine type of Private EC2 instance"
}
variable "public-ec2-user-data" {
  type = string
  description = "The startup script for the public ec2"
}
variable "private-ec2-user-data" {
  type = string
  description = "The startup script for the private ec2"
}
variable "ec2-private-tags" {
    type = map(string)
    description = "Name of the Private EC2"
}
variable "ec2-public-tags" {
  type = map(string)
  description = "Name of Public EC2"
}