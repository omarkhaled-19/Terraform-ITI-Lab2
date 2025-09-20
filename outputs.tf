#Public EC2 Public IP
output "public_ec2_public_ip" {
  description = "The Public Ip of the public ec2 instance"
  value = aws_instance.lab2-public-webserver.public_ip
}

#Public EC2 Private IP
output "public_ec2_private_ip" {
  description = "Private Ip of Public ec2 instance"
  value = aws_instance.lab2-public-webserver.private_ip
}
#Test the public ec2
output "public_ec2_http_url" {
  description = "HTTP URL to access the public EC2 web server"
  value       = "http://${aws_instance.lab2-public-webserver.public_ip}"
}

#Private EC2 Private IP
output "private_ec2_private_ip" {
  description = "Private IP of private ec2 instance"
  value = aws_instance.lab2-private-webserver.private_ip
}

output "nat_gateway_eip" {
  description = "NAT gateway elastic ip to test private ec2 internet access"
  value = aws_eip.nat_eip.public_ip
}


