output "instance_id" {
  description = "ID da EC2"
  value       = module.servidor_web.instancia_id
}

output "public_ip" {
  description = "IP publico da EC2"
  value       = module.servidor_web.ip_publico
}

output "private_ip" {
  description = "IP privado da EC2"
  value       = module.servidor_web.ip_privado
}

output "public_dns" {
  description = "DNS publico da EC2"
  value       = module.servidor_web.dns_publico
}