variable "nome_projeto" {
  description = "Nome usado como prefixo para identificar os recursos deste modulo."
  type        = string
}

variable "environment" {
  description = "Ambiente onde os recursos serao criados."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia EC2 (mantenha t2.micro ou t3.micro para caber no Free Tier)."
  type        = string
}

variable "security_group_id" {
  description = "ID do Security Group"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet"
  type        = string
}
