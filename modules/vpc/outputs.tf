output "aws_vpc_app_vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "aws_subnet_private1_id" {
  value = aws_subnet.private1.id
}

output "aws_subnet_private2_id" {
  value = aws_subnet.private2.id
}

output "aws_subnet_public1_id" {
  value = aws_subnet.public1.id
}

output "aws_subnet_public2_id" {
  value = aws_subnet.public2.id
}

output "aws_security_group_allow_all_traffic_id" {
  value = aws_security_group.allow_all_traffic.id
}