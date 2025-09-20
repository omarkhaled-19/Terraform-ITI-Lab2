# Terraform AWS VPC Lab 2

This repository contains the Terraform configuration for **Lab 2**, where we deploy a basic AWS network infrastructure consisting of a **VPC, public/private subnets, Internet Gateway, NAT Gateway, route tables, security groups, and EC2 instances**.

---

## 📂 Repository Contents

- `main.tf` – Main Terraform configuration defining AWS resources (VPC, subnets, IGW, NAT, route tables, security groups, EC2).
- `variables.tf` – Variable declarations with types and descriptions.
- `terraform.tfvars` – Variable values (excluded from GitHub if it contains sensitive values).
- `outputs.tf` – Terraform outputs (public/private IPs, NAT gateway EIP, etc.).
- `terraform.tf` – Additional Terraform configuration if needed (e.g., provider).
- `Terraform-lab2.pdf` – Lab report/documentation.

---

## 🏗️ Architecture Overview

The deployed infrastructure includes:
- **VPC** with CIDR `10.0.0.0/16`
- **Public Subnet**:
  - Internet Gateway for inbound/outbound traffic
  - EC2 instance (public webserver / bastion host)
- **Private Subnet**:
  - NAT Gateway for outbound-only internet access
  - EC2 instance (private webserver, no public IP)
- **Route Tables**:
  - Public → 0.0.0.0/0 via IGW
  - Private → 0.0.0.0/0 via NAT
- **Security Groups**:
  - Public SG: allows SSH, HTTP, HTTPS from `0.0.0.0/0`
  - Private SG: allows SSH/HTTP from public subnet only

---

## 🚀 Usage

### 1. Prerequisites
- AWS account with IAM permissions
- AWS CLI installed and configured (`aws configure`)
- Terraform >= 1.5 installed
- An SSH key pair created in AWS (e.g., `lab2-key`)

### 2. Initialize Terraform
In your local machine console in the project directory:
```bash
terraform init
terraform plan
terraform apply -auto-approve
```



