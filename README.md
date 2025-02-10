# iac-alura

Projeto de Infraestrutura como Código (IaC) utilizando Terraform e Ansible para provisionamento e configuração de ambientes no GCloud. Estudos da Alura.

## Estrutura do Projeto

```
├── infra/
│   ├── main.tf  # Configuração principal do Terraform
│   ├── variables.tf  # Variáveis para o Terraform
│   ├── hosts.yml  # Inventário do Ansible
│
├── env/
│   ├── Dev/
│   │   ├── main.tf  # Configuração específica para o ambiente de Desenvolvimento
│   │   ├── playbook.yml  # Playbook Ansible para Dev
│   │
│   ├── Prod/
│   │   ├── main.tf  # Configuração específica para o ambiente de Produção
│   │   ├── playbook.yml  # Playbook Ansible para Prod
```

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Chaves SSH configuradas

## Configuração da Chave SSH

Gerar um par de chaves SSH para autenticação:

```sh
ssh-keygen -t rsa -b 4096 -f iac-alura-key-dev
```

## Uso

### 1. Provisionar Infraestrutura com Terraform

Acesse o diretório correspondente ao ambiente (Dev ou Prod) e execute:

```sh
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

### 2. Configurar Servidores com Ansible

Após provisionar a infraestrutura, execute o playbook para configurar os servidores de Dev:

```sh
ansible-playbook ./env/Dev/playbook.yml -u user-dev --private-key iac-alura-key-dev -i ./infra/hosts.yml
```

Para o ambiente de Produção, altere os parâmetros conforme necessário.
