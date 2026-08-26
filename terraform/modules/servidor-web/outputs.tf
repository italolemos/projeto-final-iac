output "ip_publico" {
  description = "IP publico da instancia criada por este modulo."
  value       = aws_instance.web.public_ip
}

output "dns_publico" {
  description = "DNS publico da instancia criada por este modulo."
  value       = aws_instance.web.public_dns
}

output "instancia_id" {
  description = "ID instancia EC2"
  value       = aws_instance.web.id
}

output "ip_privado" {
  description = "IP privado da EC2"
  value       = aws_instance.web.private_ip
}