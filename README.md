# iac-alura

Projeto de Infraestrutura como Código (IaC) utilizando Terraform e Ansible para provisionamento e configuração de ambientes na Magalu Cloud. Estudos da Alura.

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

```sh
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

```sh
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible
```

- Chaves SSH configuradas

## Configuração da API Key

Crie o arquivo apikey

```sh
echo valor_apikey > apikey
```

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
ansible-playbook ./env/Dev/playbook.yml -u ubuntu --private-key iac-alura-key-dev -i ./infra/hosts.yml
```

Para o ambiente de Produção, altere os parâmetros conforme necessário.
