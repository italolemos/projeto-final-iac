module "security" {
  source = "./modules/security"

  nome_projeto = var.nome_projeto
}

module "servidor_web" {
  source = "./modules/servidor-web"

  nome_projeto      = var.nome_projeto
  environment       = terraform.workspace
  subnet_id         = module.security.public_subnet_id
  security_group_id = module.security.security_group_id
  instance_type     = var.instance_type
}