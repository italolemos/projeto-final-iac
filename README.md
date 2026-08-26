# Projeto Terraform AWS — Servidor Web

## 1. Descrição

Projeto desenvolvido para provisionamento de uma infraestrutura web na AWS utilizando Terraform.

A infraestrutura possui:

* VPC;
* Subnet pública;
* Internet Gateway;
* Route Table;
* Rota `0.0.0.0/0` para o Internet Gateway;
* Security Group;
* Instância EC2;
* Amazon Linux 2023;
* Servidor Apache HTTP;
* Página HTML personalizada;
* Backend remoto utilizando S3;
* Ambientes independentes `dev` e `prod`;
* Módulo próprio `servidor-web`.

---

## 2. Estrutura do projeto

```text
terraform/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── modules/
    └── servidor-web/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## 3. Backend remoto

O projeto utiliza backend remoto S3 para armazenamento do Terraform State.

### Bucket

```text
pos-devops-iac-terraform-state-atividade-01
```

### Região

```text
us-east-1
```

### Configuração

```hcl
backend "s3" {
  bucket       = "pos-devops-iac-terraform-state-atividade-01"
  key          = "environments/<ambiente>/terraform.tfstate"
  region       = "us-east-1"
  use_lockfile = true
}
```

O bucket S3 foi criado manualmente antes da execução do projeto Terraform.

---

# 4. Ambientes

Cada ambiente e um root module independente e possui seu proprio state no backend S3:

| Ambiente | Tipo da EC2 | State                                      | Finalidade                        |
| --------- | ----------- | --------------------------------- |
| `dev`     | `t2.micro`  | `environments/dev/terraform.tfstate`  | Ambiente de desenvolvimento/teste |
| `prod`    | `t3.micro`  | `environments/prod/terraform.tfstate` | Ambiente de produção              |

Para provisionar um ambiente, execute os comandos dentro do diretorio correspondente:

```bash
cd environments/dev
terraform init
terraform plan -var='meu_ip_cidr=SEU_IP/32'
terraform apply -var='meu_ip_cidr=SEU_IP/32'
```

Para producao, use `cd environments/prod`. Nao e necessario criar ou selecionar workspaces.

---

# 5. Evidências de entrega

As evidências abaixo foram obtidas após a execução efetiva do Terraform nos dois ambientes.
---

## 5.1 Evidências — Ambiente `dev`

### Ambiente utilizado

Comando executado:

```bash
cd environments/dev
terraform init
```

Saída:

```text
dev
```


### Terraform Apply

Comando executado:

```bash
terraform apply
```

Resultado:

```text
$:~/Documents/aula_iac/atividade-01$ terraform apply
var.meu_ip_cidr
  CIDR do seu IP publico, no formato IP/32, autorizado a acessar a porta 22. Descubra com: curl -s https://checkip.amazonaws.com

  Enter a value: <meu_ip>/32

module.servidor_web.data.aws_ami.amazon_linux_2023: Reading...
module.servidor_web.data.aws_ami.amazon_linux_2023: Read complete after 1s [id=ami-0260fb21be1fd50db]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "igw-dev"
        }
      + tags_all = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "igw-dev"
        }
      + vpc_id   = (known after apply)
    }

  # aws_route_table.route_table will be created
  + resource "aws_route_table" "route_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + cidr_block                 = "0.0.0.0/0"
              + gateway_id                 = (known after apply)
                # (11 unchanged attributes hidden)
            },
        ]
      + tags             = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "public-rt-dev"
        }
      + tags_all         = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "public-rt-dev"
        }
      + vpc_id           = (known after apply)
    }

  # aws_subnet.main will be created
  + resource "aws_subnet" "main" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "public-subnet-dev"
        }
      + tags_all                                       = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "public-subnet-dev"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.vpc will be created
  + resource "aws_vpc" "vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "vpc-dev"
        }
      + tags_all                             = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "vpc-dev"
        }
    }

  # module.servidor_web.aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami                                  = "ami-0260fb21be1fd50db"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "instancia-ec2-pos-devops-iac-modulos-dev"
        }
      + tags_all                             = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "instancia-ec2-pos-devops-iac-modulos-dev"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "33f9def258a1d76f0ef8f5ecd0de29334a4db511"
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # module.servidor_web.aws_security_group.web will be created
  + resource "aws_security_group" "web" {
      + arn                    = (known after apply)
      + description            = "Libera SSH restrito e a porta de aplicacao do modulo servidor-web"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Porta de aplicacao"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
          + {
              + cidr_blocks      = [
                  + "179.48.15.40/32",
                ]
              + description      = "SSH apenas do IP autorizado"
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
        ]
      + name                   = "secgrp-pos-devops-iac-modulos"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "security-grp-pos-devops-iac-modulos"
        }
      + tags_all               = {
          + "Ambiente" = "dev"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "security-grp-pos-devops-iac-modulos"
        }
      + vpc_id                 = (known after apply)
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + dns_publico_instancia = (known after apply)
  + environment           = "dev"
  + ip_publico_instancia  = (known after apply)

Do you want to perform these actions in workspace "dev"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.vpc: Creating...
module.servidor_web.aws_security_group.web: Creating...
aws_vpc.vpc: Creation complete after 3s [id=vpc-0694db62426fe7956]
aws_internet_gateway.igw: Creating...
aws_subnet.main: Creating...
aws_internet_gateway.igw: Creation complete after 1s [id=igw-08ee0151322729699]
aws_route_table.route_table: Creating...
module.servidor_web.aws_security_group.web: Creation complete after 5s [id=sg-0d7d0995c1ef3d68a]
module.servidor_web.aws_instance.web: Creating...
aws_subnet.main: Creation complete after 2s [id=subnet-04426f501d9944e7b]
aws_route_table.route_table: Creation complete after 2s [id=rtb-05f48f001935f1aff]
module.servidor_web.aws_instance.web: Still creating... [00m10s elapsed]
module.servidor_web.aws_instance.web: Creation complete after 14s [id=i-072fc6b193376f918]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

dns_publico_instancia = "ec2-13-217-35-131.compute-1.amazonaws.com"
environment = "dev"
ip_publico_instancia = "13.217.35.131"
```

**Print da execução:**

![Terraform Apply — DEV](02-apply-dev.png)

---

### Terraform destroy

Comando:

```bash
terraform destroy
```

Resultado:

```bash
$:~/Documents/aula_iac/atividade-01$ terraform destroy
var.meu_ip_cidr
  CIDR do seu IP publico, no formato IP/32, autorizado a acessar a porta 22. Descubra com: curl -s https://checkip.amazonaws.com

  Enter a value: <meu-ip>/32

aws_vpc.vpc: Refreshing state... [id=vpc-0694db62426fe7956]
module.servidor_web.data.aws_ami.amazon_linux_2023: Reading...
module.servidor_web.aws_security_group.web: Refreshing state... [id=sg-0d7d0995c1ef3d68a]
module.servidor_web.data.aws_ami.amazon_linux_2023: Read complete after 5s [id=ami-0260fb21be1fd50db]
module.servidor_web.aws_instance.web: Refreshing state... [id=i-072fc6b193376f918]
aws_internet_gateway.igw: Refreshing state... [id=igw-08ee0151322729699]
aws_subnet.main: Refreshing state... [id=subnet-04426f501d9944e7b]
aws_route_table.route_table: Refreshing state... [id=rtb-05f48f001935f1aff]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_internet_gateway.igw will be destroyed
  - resource "aws_internet_gateway" "igw" {
      - arn      = "arn:aws:ec2:us-east-1:774640187799:internet-gateway/igw-08ee0151322729699" -> null
      - id       = "igw-08ee0151322729699" -> null
      - owner_id = "774640187799" -> null
      - tags     = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "igw-dev"
        } -> null
      - tags_all = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "igw-dev"
        } -> null
      - vpc_id   = "vpc-0694db62426fe7956" -> null
    }

  # aws_route_table.route_table will be destroyed
  - resource "aws_route_table" "route_table" {
      - arn              = "arn:aws:ec2:us-east-1:774640187799:route-table/rtb-05f48f001935f1aff" -> null
      - id               = "rtb-05f48f001935f1aff" -> null
      - owner_id         = "774640187799" -> null
      - propagating_vgws = [] -> null
      - route            = [
          - {
              - cidr_block                 = "0.0.0.0/0"
              - gateway_id                 = "igw-08ee0151322729699"
                # (11 unchanged attributes hidden)
            },
        ] -> null
      - tags             = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "public-rt-dev"
        } -> null
      - tags_all         = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "public-rt-dev"
        } -> null
      - vpc_id           = "vpc-0694db62426fe7956" -> null
    }

  # aws_subnet.main will be destroyed
  - resource "aws_subnet" "main" {
      - arn                                            = "arn:aws:ec2:us-east-1:774640187799:subnet/subnet-04426f501d9944e7b" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-1d" -> null
      - availability_zone_id                           = "use1-az4" -> null
      - cidr_block                                     = "10.0.1.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-04426f501d9944e7b" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "774640187799" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "public-subnet-dev"
        } -> null
      - tags_all                                       = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "public-subnet-dev"
        } -> null
      - vpc_id                                         = "vpc-0694db62426fe7956" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_vpc.vpc will be destroyed
  - resource "aws_vpc" "vpc" {
      - arn                                  = "arn:aws:ec2:us-east-1:774640187799:vpc/vpc-0694db62426fe7956" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/16" -> null
      - default_network_acl_id               = "acl-0ce49a20b139c0b60" -> null
      - default_route_table_id               = "rtb-09923a03f69224297" -> null
      - default_security_group_id            = "sg-08e6cf12274a68e03" -> null
      - dhcp_options_id                      = "dopt-08c101844708e9f96" -> null
      - enable_dns_hostnames                 = false -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-0694db62426fe7956" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-09923a03f69224297" -> null
      - owner_id                             = "774640187799" -> null
      - tags                                 = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "vpc-dev"
        } -> null
      - tags_all                             = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "vpc-dev"
        } -> null
        # (4 unchanged attributes hidden)
    }

  # module.servidor_web.aws_instance.web will be destroyed
  - resource "aws_instance" "web" {
      - ami                                  = "ami-0260fb21be1fd50db" -> null
      - arn                                  = "arn:aws:ec2:us-east-1:774640187799:instance/i-072fc6b193376f918" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-1a" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-072fc6b193376f918" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-06b43cccca4477d6b" -> null
      - private_dns                          = "ip-172-31-43-117.ec2.internal" -> null
      - private_ip                           = "172.31.43.117" -> null
      - public_dns                           = "ec2-13-217-35-131.compute-1.amazonaws.com" -> null
      - public_ip                            = "13.217.35.131" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "secgrp-pos-devops-iac-modulos",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-00d93be78d1f203e3" -> null
      - tags                                 = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "instancia-ec2-pos-devops-iac-modulos-dev"
        } -> null
      - tags_all                             = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "instancia-ec2-pos-devops-iac-modulos-dev"
        } -> null
      - tenancy                              = "default" -> null
      - user_data                            = "33f9def258a1d76f0ef8f5ecd0de29334a4db511" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-0d7d0995c1ef3d68a",
        ] -> null
        # (8 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-02309e2dbaf1dc4d1" -> null
          - volume_size           = 30 -> null
          - volume_type           = "gp3" -> null
            # (1 unchanged attribute hidden)
        }
    }

  # module.servidor_web.aws_security_group.web will be destroyed
  - resource "aws_security_group" "web" {
      - arn                    = "arn:aws:ec2:us-east-1:774640187799:security-group/sg-0d7d0995c1ef3d68a" -> null
      - description            = "Libera SSH restrito e a porta de aplicacao do modulo servidor-web" -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - id                     = "sg-0d7d0995c1ef3d68a" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "Porta de aplicacao"
              - from_port        = 80
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 80
            },
          - {
              - cidr_blocks      = [
                  - "179.48.15.40/32",
                ]
              - description      = "SSH apenas do IP autorizado"
              - from_port        = 22
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 22
            },
        ] -> null
      - name                   = "secgrp-pos-devops-iac-modulos" -> null
      - owner_id               = "774640187799" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "security-grp-pos-devops-iac-modulos"
        } -> null
      - tags_all               = {
          - "Ambiente" = "dev"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "security-grp-pos-devops-iac-modulos"
        } -> null
      - vpc_id                 = "vpc-0ca0078d8b824e7f4" -> null
        # (1 unchanged attribute hidden)
    }

Plan: 0 to add, 0 to change, 6 to destroy.

Changes to Outputs:
  - dns_publico_instancia = "ec2-13-217-35-131.compute-1.amazonaws.com" -> null
  - environment           = "dev" -> null
  - ip_publico_instancia  = "13.217.35.131" -> null

Do you really want to destroy all resources in workspace "dev"?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_route_table.route_table: Destroying... [id=rtb-05f48f001935f1aff]
aws_subnet.main: Destroying... [id=subnet-04426f501d9944e7b]
module.servidor_web.aws_instance.web: Destroying... [id=i-072fc6b193376f918]
aws_subnet.main: Destruction complete after 2s
aws_route_table.route_table: Destruction complete after 2s
aws_internet_gateway.igw: Destroying... [id=igw-08ee0151322729699]
aws_internet_gateway.igw: Destruction complete after 1s
aws_vpc.vpc: Destroying... [id=vpc-0694db62426fe7956]
aws_vpc.vpc: Destruction complete after 1s
module.servidor_web.aws_instance.web: Still destroying... [id=i-072fc6b193376f918, 00m10s elapsed]
module.servidor_web.aws_instance.web: Still destroying... [id=i-072fc6b193376f918, 00m20s elapsed]
module.servidor_web.aws_instance.web: Still destroying... [id=i-072fc6b193376f918, 00m30s elapsed]
module.servidor_web.aws_instance.web: Destruction complete after 32s
module.servidor_web.aws_security_group.web: Destroying... [id=sg-0d7d0995c1ef3d68a]
module.servidor_web.aws_security_group.web: Destruction complete after 1s

Destroy complete! Resources: 6 destroyed.
```

# 5.2 Evidências — Ambiente `prod`

### Ambiente utilizado

Comandos executados:

```bash
cd environments/prod
terraform init
```

Saída:

```text
prod
```

### Terraform Apply

Comando executado:

```bash
terraform apply
```

Resultado:

```bash
italo-lemos@ENCSABCAMLT0401:~/Documents/aula_iac/atividade-01$ terraform apply
var.meu_ip_cidr
  CIDR do seu IP publico, no formato IP/32, autorizado a acessar a porta 22. Descubra com: curl -s https://checkip.amazonaws.com

  Enter a value: 179.48.15.40/32

module.servidor_web.data.aws_ami.amazon_linux_2023: Reading...
module.servidor_web.data.aws_ami.amazon_linux_2023: Read complete after 2s [id=ami-0260fb21be1fd50db]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "igw-prod"
        }
      + tags_all = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "igw-prod"
        }
      + vpc_id   = (known after apply)
    }

  # aws_route_table.route_table will be created
  + resource "aws_route_table" "route_table" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + cidr_block                 = "0.0.0.0/0"
              + gateway_id                 = (known after apply)
                # (11 unchanged attributes hidden)
            },
        ]
      + tags             = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "public-rt-prod"
        }
      + tags_all         = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "public-rt-prod"
        }
      + vpc_id           = (known after apply)
    }

  # aws_subnet.main will be created
  + resource "aws_subnet" "main" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "public-subnet-prod"
        }
      + tags_all                                       = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "public-subnet-prod"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.vpc will be created
  + resource "aws_vpc" "vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "vpc-prod"
        }
      + tags_all                             = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "vpc-prod"
        }
    }

  # module.servidor_web.aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami                                  = "ami-0260fb21be1fd50db"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t3.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "instancia-ec2-pos-devops-iac-modulos-prod"
        }
      + tags_all                             = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "instancia-ec2-pos-devops-iac-modulos-prod"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "33f9def258a1d76f0ef8f5ecd0de29334a4db511"
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

  # module.servidor_web.aws_security_group.web will be created
  + resource "aws_security_group" "web" {
      + arn                    = (known after apply)
      + description            = "Libera SSH restrito e a porta de aplicacao do modulo servidor-web"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Porta de aplicacao"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
          + {
              + cidr_blocks      = [
                  + "179.48.15.40/32",
                ]
              + description      = "SSH apenas do IP autorizado"
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
        ]
      + name                   = "secgrp-pos-devops-iac-modulos"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "security-grp-pos-devops-iac-modulos"
        }
      + tags_all               = {
          + "Ambiente" = "prod"
          + "Curso"    = "pos-devops-iac"
          + "Name"     = "security-grp-pos-devops-iac-modulos"
        }
      + vpc_id                 = (known after apply)
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + dns_publico_instancia = (known after apply)
  + environment           = "prod"
  + ip_publico_instancia  = (known after apply)

Do you want to perform these actions in workspace "prod"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.vpc: Creating...
module.servidor_web.aws_security_group.web: Creating...
aws_vpc.vpc: Creation complete after 4s [id=vpc-07e29368714a612b8]
aws_internet_gateway.igw: Creating...
aws_subnet.main: Creating...
aws_internet_gateway.igw: Creation complete after 1s [id=igw-0a70fb54277072bd6]
aws_route_table.route_table: Creating...
aws_subnet.main: Creation complete after 1s [id=subnet-05305647876c30d12]
module.servidor_web.aws_security_group.web: Creation complete after 5s [id=sg-0d024b17b99e179a8]
module.servidor_web.aws_instance.web: Creating...
aws_route_table.route_table: Creation complete after 1s [id=rtb-0c790a9a82e20b2a2]
module.servidor_web.aws_instance.web: Still creating... [00m10s elapsed]
module.servidor_web.aws_instance.web: Creation complete after 14s [id=i-016e6fc5043edd587]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

dns_publico_instancia = "ec2-13-222-4-28.compute-1.amazonaws.com"
environment = "prod"
ip_publico_instancia = "13.222.4.28"
```

**Print da execução:**

![Terraform Apply — PROD](02-apply-prod.png)

---

### Outputs

Comando:

```bash
terraform destroy
```

Resultado:

```bash
$:~/Documents/aula_iac/atividade-01$ terraform destroy
var.meu_ip_cidr
  CIDR do seu IP publico, no formato IP/32, autorizado a acessar a porta 22. Descubra com: curl -s https://checkip.amazonaws.com

  Enter a value: <meu-ip>/32

aws_vpc.vpc: Refreshing state... [id=vpc-07e29368714a612b8]
module.servidor_web.data.aws_ami.amazon_linux_2023: Reading...
module.servidor_web.aws_security_group.web: Refreshing state... [id=sg-0d024b17b99e179a8]
module.servidor_web.data.aws_ami.amazon_linux_2023: Read complete after 1s [id=ami-0260fb21be1fd50db]
module.servidor_web.aws_instance.web: Refreshing state... [id=i-016e6fc5043edd587]
aws_internet_gateway.igw: Refreshing state... [id=igw-0a70fb54277072bd6]
aws_subnet.main: Refreshing state... [id=subnet-05305647876c30d12]
aws_route_table.route_table: Refreshing state... [id=rtb-0c790a9a82e20b2a2]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_internet_gateway.igw will be destroyed
  - resource "aws_internet_gateway" "igw" {
      - arn      = "arn:aws:ec2:us-east-1:774640187799:internet-gateway/igw-0a70fb54277072bd6" -> null
      - id       = "igw-0a70fb54277072bd6" -> null
      - owner_id = "774640187799" -> null
      - tags     = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "igw-prod"
        } -> null
      - tags_all = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "igw-prod"
        } -> null
      - vpc_id   = "vpc-07e29368714a612b8" -> null
    }

  # aws_route_table.route_table will be destroyed
  - resource "aws_route_table" "route_table" {
      - arn              = "arn:aws:ec2:us-east-1:774640187799:route-table/rtb-0c790a9a82e20b2a2" -> null
      - id               = "rtb-0c790a9a82e20b2a2" -> null
      - owner_id         = "774640187799" -> null
      - propagating_vgws = [] -> null
      - route            = [
          - {
              - cidr_block                 = "0.0.0.0/0"
              - gateway_id                 = "igw-0a70fb54277072bd6"
                # (11 unchanged attributes hidden)
            },
        ] -> null
      - tags             = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "public-rt-prod"
        } -> null
      - tags_all         = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "public-rt-prod"
        } -> null
      - vpc_id           = "vpc-07e29368714a612b8" -> null
    }

  # aws_subnet.main will be destroyed
  - resource "aws_subnet" "main" {
      - arn                                            = "arn:aws:ec2:us-east-1:774640187799:subnet/subnet-05305647876c30d12" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-1d" -> null
      - availability_zone_id                           = "use1-az4" -> null
      - cidr_block                                     = "10.0.1.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-05305647876c30d12" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "774640187799" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "public-subnet-prod"
        } -> null
      - tags_all                                       = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "public-subnet-prod"
        } -> null
      - vpc_id                                         = "vpc-07e29368714a612b8" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_vpc.vpc will be destroyed
  - resource "aws_vpc" "vpc" {
      - arn                                  = "arn:aws:ec2:us-east-1:774640187799:vpc/vpc-07e29368714a612b8" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/16" -> null
      - default_network_acl_id               = "acl-08c23a6edcac6c8ac" -> null
      - default_route_table_id               = "rtb-0456400bee2c1477d" -> null
      - default_security_group_id            = "sg-0a04c7a062bbb9466" -> null
      - dhcp_options_id                      = "dopt-08c101844708e9f96" -> null
      - enable_dns_hostnames                 = false -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-07e29368714a612b8" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-0456400bee2c1477d" -> null
      - owner_id                             = "774640187799" -> null
      - tags                                 = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "vpc-prod"
        } -> null
      - tags_all                             = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "vpc-prod"
        } -> null
        # (4 unchanged attributes hidden)
    }

  # module.servidor_web.aws_instance.web will be destroyed
  - resource "aws_instance" "web" {
      - ami                                  = "ami-0260fb21be1fd50db" -> null
      - arn                                  = "arn:aws:ec2:us-east-1:774640187799:instance/i-016e6fc5043edd587" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-1d" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 2 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-016e6fc5043edd587" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t3.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-09615c37accf86c84" -> null
      - private_dns                          = "ip-172-31-23-43.ec2.internal" -> null
      - private_ip                           = "172.31.23.43" -> null
      - public_dns                           = "ec2-13-222-4-28.compute-1.amazonaws.com" -> null
      - public_ip                            = "13.222.4.28" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "secgrp-pos-devops-iac-modulos",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-0043faefdef23e6d2" -> null
      - tags                                 = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "instancia-ec2-pos-devops-iac-modulos-prod"
        } -> null
      - tags_all                             = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "instancia-ec2-pos-devops-iac-modulos-prod"
        } -> null
      - tenancy                              = "default" -> null
      - user_data                            = "33f9def258a1d76f0ef8f5ecd0de29334a4db511" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-0d024b17b99e179a8",
        ] -> null
        # (8 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 2 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "unlimited" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-060595b3c02368f9b" -> null
          - volume_size           = 30 -> null
          - volume_type           = "gp3" -> null
            # (1 unchanged attribute hidden)
        }
    }

  # module.servidor_web.aws_security_group.web will be destroyed
  - resource "aws_security_group" "web" {
      - arn                    = "arn:aws:ec2:us-east-1:774640187799:security-group/sg-0d024b17b99e179a8" -> null
      - description            = "Libera SSH restrito e a porta de aplicacao do modulo servidor-web" -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - id                     = "sg-0d024b17b99e179a8" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "Porta de aplicacao"
              - from_port        = 80
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 80
            },
          - {
              - cidr_blocks      = [
                  - "179.48.15.40/32",
                ]
              - description      = "SSH apenas do IP autorizado"
              - from_port        = 22
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 22
            },
        ] -> null
      - name                   = "secgrp-pos-devops-iac-modulos" -> null
      - owner_id               = "774640187799" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "security-grp-pos-devops-iac-modulos"
        } -> null
      - tags_all               = {
          - "Ambiente" = "prod"
          - "Curso"    = "pos-devops-iac"
          - "Name"     = "security-grp-pos-devops-iac-modulos"
        } -> null
      - vpc_id                 = "vpc-0ca0078d8b824e7f4" -> null
        # (1 unchanged attribute hidden)
    }

Plan: 0 to add, 0 to change, 6 to destroy.

Changes to Outputs:
  - dns_publico_instancia = "ec2-13-222-4-28.compute-1.amazonaws.com" -> null
  - environment           = "prod" -> null
  - ip_publico_instancia  = "13.222.4.28" -> null

Do you really want to destroy all resources in workspace "prod"?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_subnet.main: Destroying... [id=subnet-05305647876c30d12]
aws_route_table.route_table: Destroying... [id=rtb-0c790a9a82e20b2a2]
module.servidor_web.aws_instance.web: Destroying... [id=i-016e6fc5043edd587]
aws_subnet.main: Destruction complete after 2s
aws_route_table.route_table: Destruction complete after 2s
aws_internet_gateway.igw: Destroying... [id=igw-0a70fb54277072bd6]
aws_internet_gateway.igw: Destruction complete after 1s
aws_vpc.vpc: Destroying... [id=vpc-07e29368714a612b8]
aws_vpc.vpc: Destruction complete after 1s
module.servidor_web.aws_instance.web: Still destroying... [id=i-016e6fc5043edd587, 00m10s elapsed]
module.servidor_web.aws_instance.web: Still destroying... [id=i-016e6fc5043edd587, 00m20s elapsed]
module.servidor_web.aws_instance.web: Still destroying... [id=i-016e6fc5043edd587, 00m30s elapsed]
module.servidor_web.aws_instance.web: Still destroying... [id=i-016e6fc5043edd587, 00m40s elapsed]
module.servidor_web.aws_instance.web: Destruction complete after 43s
module.servidor_web.aws_security_group.web: Destroying... [id=sg-0d024b17b99e179a8]
module.servidor_web.aws_security_group.web: Destruction complete after 1s

Destroy complete! Resources: 6 destroyed.

$:~/Documents/aula_iac/atividade-01$ terraform workspace show
prod
```
