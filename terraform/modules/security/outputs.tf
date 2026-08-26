output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.web.id
}

output "public_subnet_id" {
  description = "ID da subnet pública"
  value       = aws_subnet.public.id
}