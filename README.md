# Projeto Final — Infraestrutura como Código

Projeto desenvolvido para a atividade final da disciplina de Infraestrutura como Código, utilizando **Terraform + Ansible** para provisionamento e configuração de uma aplicação web na AWS.

O projeto implementa o fluxo:

Terraform → Infraestrutura AWS → Inventário dinâmico → Ansible → Docker → Aplicação

A aplicação utilizada é a `getting-started-app`, exemplo oficial do Docker utilizado no tutorial Getting Started.

---

## 1. Objetivo

O objetivo do projeto é demonstrar a integração entre Terraform e Ansible, mantendo uma separação clara de responsabilidades:

- **Terraform** é responsável pelo provisionamento da infraestrutura AWS.
- **Ansible** é responsável pela configuração da instância EC2.
- **Docker** é instalado pelo Ansible.
- A aplicação `getting-started-app` é executada pelo Ansible utilizando módulos idempotentes da coleção `community.docker`.

Não é utilizado `remote-exec` no Terraform.

A configuração do servidor não é realizada manualmente por SSH.

---

# 2. Arquitetura

A arquitetura foi projetada para separar infraestrutura de configuração.

```text
                              INTERNET
                                  |
                                  v
                         +------------------+
                         | Internet Gateway |
                         +--------+---------+
                                  |
                                  v
                    +---------------------------+
                    | VPC                       |
                    | 10.0.0.0/16              |
                    |                           |
                    |  Public Subnet            |
                    |  10.0.1.0/24              |
                    |                           |
                    |  +---------------------+  |
                    |  | Security Group       |  |
                    |  |                     |  |
                    |  | TCP 22  - SSH       |  |
                    |  | TCP 3000 - App      |  |
                    |  +----------+----------+  |
                    |             |             |
                    |             v             |
                    |  +---------------------+  |
                    |  | EC2 t3.micro        |  |
                    |  |                     |  |
                    |  | Amazon Linux 2023   |  |
                    |  |                     |  |
                    |  | Docker Engine       |  |
                    |  |                     |  |
                    |  | getting-started-app |  |
                    |  | container : 3000    |  |
                    |  +---------------------+  |
                    +---------------------------+

                         ^ 
                         |
                    Terraform apply
                         |
                         v
                 Inventário dinâmico
                         |
                         v
                   ansible-playbook
                         |
                         v
                    Ansible Roles
                    /           \
                   /             \
             docker            aplicacao
                |                   |
                v                   v
        Instala Docker         Instala Git
                                   |
                                   v
                         Clone e Build da aplicação   
                                   |
                                   v
                            Cria Container
                               3000:3000             
```

---

## 3. Integração Terraform → Ansible
**Estratégia escolhida**

Foi utilizada a Opção A: inventário dinâmico + execução manual.

O Terraform provisiona a infraestrutura e, após a conclusão do `terraform apply`, o Ansible consulta diretamente a AWS para descobrir as instâncias em execução.

O inventário não possui IPs fixos. Se encontra definido no arquivo:
```
ansible/inventory/aws_ec2.yml
```
O endereço utilizado pelo Ansible é obtido dinamicamente através do atributo: `public_ip_address`

Dessa forma, caso a instância seja destruída e recriada e receba outro IP público, não é necessário editar manualmente o inventário.

---

## 4. Fluxo de execução

1. O Terraform é responsável pelo provisionamento da seguinte infraestrutura.
- VPC;
- Subnet pública;
- Internet Gateway;
- Route Table;
- Security Group;
- Instância EC2;
- chave utilizada para acesso SSH;

2. Inventário dinâmico consulta a AWS

3. O Ansible é responsável pela configuração da instância.

- instalação do Docker Engine;
- habilitação e inicialização do serviço Docker;
- inclusão do usuário ec2-user no grupo Docker;
- download da imagem docker/getting-started;
- criação e execução do container getting-started-app.

## 5. Execução do Projeto

Entre no diretório 

```
cd terraform
```

Inicialize o Terraform:
```
terraform init
```

O projeto utiliza Terraform Workspaces para separar os ambientes:
```
dev
prod
```
Para utilizar o ambiente de desenvolvimento:
```
terraform workspace new dev
terraform workspace select dev
```

##### Applicar o Provisionamento
Executar:
```
terraform apply -var-file="environments/dev.tfvars"
```

##### Configuração do Ansible
Entre no diretório e Instale as coleções necessárias:

```
cd ansible
ansible-galaxy collection install -r requirements.yml
```

Valide o inventário.
O endereço público da EC2 é obtido dinamicamente pelo inventário.
```
ansible-inventory --graph

@all:
  |--@ungrouped:
  |--@aws_ec2:
  |  |--ip-10-0-1-225.ec2.internal

```
Teste a conectividade antes de executar as roles:
```
ansible aws_ec2 -m ping
```

##### Execução do ansible
```
ansible-playbook playbook.yml
```

Teste o acesso exeterno através do ip-publico
```
http://IP_PUBLICO:3000
```

## 6. Passos de destruição
Execute
```
terraform destroy -var-file="environments/dev.tfvars"
```

## 7. Evidências do provisionamento da infraestrutura e registro da aplicação

[Visualizar evidências](./evidencias/)                       