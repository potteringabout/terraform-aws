output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = {
    for subnet_name, subnet in aws_subnet.subnet : subnet_name => subnet.id
  }
}
