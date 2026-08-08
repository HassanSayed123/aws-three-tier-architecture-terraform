# 🏗️ Enterprise AWS Three-Tier Architecture Migration (RetailEdge Inc.)

[![Terraform](https://img.shields.io/badge/IaC-Terraform_v1.5+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Three--Tier-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?logo=github-actions)](https://github.com/features/actions)

An end-to-end cloud migration strategy and Infrastructure as Code (IaC) implementation for **RetailEdge Inc.**, moving a high-traffic e-commerce platform from legacy on-premises servers to a fully automated, scalable, and highly available **AWS Three-Tier Architecture**.

---

## 📋 Executive Summary & Business Scenario

* **Client Profile:** RetailEdge Inc. (Mid-size e-commerce platform with 200,000 MAU and ~12,000 peak concurrent users).
* **Legacy Challenge:** Ran on 3 bare-metal servers in a co-location center, suffering 2–3 hours of Black Friday downtime ($80,000 lost revenue annually) and 4-hour manual deployment cycles prone to human error.
* **Solution:** Replatformed to AWS using Terraform to achieve zero-downtime auto-scaling, automated CI/CD deployments, Multi-AZ database resilience, and 88%+ TCO cost savings.

---

## 🏛️ Architecture Overview

The system is deployed across **two Availability Zones (AZs)** within a custom VPC, enforcing strict network isolation across Public, Private Application, and Isolated Database subnets:

<p center">
  <img src="C:\Users\OVER CLOCK\Downloads\gg_260809_011558.jpg.jpeg" alt="AWS Three-Tier Architecture Diagram" width="100%">
</p>

---

## ⚙️ Prerequisites & Setup Guide

### 1. Remote State Backend Setup (S3 & DynamoDB)
* **Create an S3 Bucket:** Create a dedicated S3 bucket for storing `.tfstate` files with **Bucket Versioning enabled** for recovery protection.
* **Create a DynamoDB Table:** Create a DynamoDB table with a Partition Key named `LockID` (String) to enable state locking.
* **Configure `backend.tf`:** Update `environments/backend.tf` with your specific backend details:
  ```hcl
  terraform {
    backend "s3" {
      bucket         = "YOUR_BUCKET_NAME"
      key            = "backend/terraform.tfstate"
      region         = "us-east-1"
      dynamodb_table = "YOUR_DYNAMODB_TABLE_NAME"
    }
  }
  2. SSH Key Pair Generation
Generate a public-private key pair for EC2 server authentication:

Bash
cd resources/compute-key/
ssh-keygen -t rsa -b 4096 -f client_key
3. AWS Prerequisites
Route 53: Ensure a Public Hosted Zone is available for domain routing.

4. Input Variables Configuration
Create a terraform.tfvars file inside the environments/ directory:

Terraform
region           = "us-east-1"
project_name     = "retailedge"
vpc_cidr         = "10.0.0.0/16"
pub_sub_1a_cidr = "10.0.1.0/24"
pub_sub_2b_cidr = "10.0.2.0/24"
pri_sub_3a_cidr = "10.0.11.0/24"
pri_sub_4b_cidr = "10.0.12.0/24"
pri_sub_5a_cidr = "10.0.21.0/24"
pri_sub_6b_cidr = "10.0.22.0/24"
db_username      = "admin"
db_password      = "YourSecurePassword123!"
🚀 Deployment Steps
Navigate to the deployment directory:

Bash
cd environments
Initialize dependencies and remote backend:

Bash
terraform init
Inspect the execution plan:

Bash
terraform plan
Apply infrastructure changes:

Bash
terraform apply
📁 Repository Structure
Plaintext
retailedge-aws/
├── environments/            # Primary deployment environment configuration
│   ├── main.tf              # Main VPC & Subnet orchestration
│   ├── providers.tf         # AWS Provider setup
│   ├── variables.tf         # Input variables
│   ├── outputs.tf           # Provisioned infrastructure outputs
│   └── .terraform.lock.hcl  # Provider lock file
├── resources/               # Modular AWS infrastructure definitions
│   ├── VPC/                 # Subnets, Route Tables, Internet Gateway
│   ├── security-groups/     # Layered Security Group definitions
│   ├── auto-scaling/        # Launch Templates, ASG & Scaling Policies
│   ├── load-balancer/       # ALB, Target Groups & Listeners
│   ├── database/            # RDS MySQL Multi-AZ & ElastiCache Redis
│   ├── cloudfront/          # CDN Distribution
│   └── DNS/                 # Route 53 Records
├── .gitignore               # Exclusion of secrets and binaries
└── README.md                # Project documentation
👤 Author
Hassan Sayed — Solutions Architect / Infrastructure Engineer