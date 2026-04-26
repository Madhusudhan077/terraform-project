# Terraform Project

A complete Infrastructure as Code (IaC) solution using Terraform for managing cloud infrastructure on AWS.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Usage](#usage)
- [Modules](#modules)
- [Environments](#environments)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This Terraform project provides a modular, scalable infrastructure setup for AWS. It includes:

- **VPC & Networking** - Complete VPC setup with public and private subnets
- **Compute Resources** - EC2 instances with auto-scaling capabilities
- **Storage Solutions** - S3 buckets for data storage
- **Security Groups** - Configured security groups and IAM roles
- **Multi-Environment Support** - Separate configurations for dev, staging, and production

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

1. **Terraform** (v1.0+)
   ```bash
   terraform --version
   ```

2. **AWS CLI** (v2+)
   ```bash
   aws --version
   ```

3. **AWS Account** with appropriate IAM permissions

4. **Git** for version control

### AWS Credentials Setup

Configure AWS credentials using one of these methods:

```bash
# Method 1: Using AWS CLI
aws configure

# Method 2: Using environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"

# Method 3: Using AWS credentials file (~/.aws/credentials)
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
```

## 📁 Project Structure

```
terraform-project/
├── README.md                 # Project documentation
├── versions.tf              # Terraform and provider versions
├── variables.tf             # Variable definitions
├── locals.tf               # Local values and naming
├── main.tf                 # Main infrastructure configuration
├── outputs.tf              # Output values
├── terraform.tfvars.example # Example variables file
├── .gitignore             # Git ignore rules
├── LICENSE                # Project license
│
├── modules/               # Reusable modules
│   ├── networking/        # VPC, subnets, routing
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── compute/           # EC2, security groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   └── storage/           # S3 buckets
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
│
├── environments/          # Environment-specific configurations
│   ├── dev/              # Development environment
│   │   ├── terraform.tfvars
│   │   └── main.tf
│   │
│   ├── staging/          # Staging environment
│   │   ├── terraform.tfvars
│   │   └── main.tf
│   │
│   └── prod/             # Production environment
│       ├── terraform.tfvars
│       └── main.tf
│
└── scripts/              # Utility scripts
    ├── init.sh          # Initialize Terraform
    ├── plan.sh          # Plan changes
    ├── apply.sh         # Apply changes
    └── destroy.sh       # Destroy infrastructure
```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/Madhusudhan077/terraform-project.git
cd terraform-project
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Create Variables File

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your desired values:

```hcl
aws_region = "us-east-1"
environment = "dev"
project_name = "my-project"
```

### 4. Validate Configuration

```bash
terraform validate
```

### 5. Plan Infrastructure

```bash
terraform plan -out=tfplan
```

### 6. Apply Configuration

```bash
terraform apply tfplan
```

### 7. View Outputs

```bash
terraform output
```

## ⚙️ Configuration

### Variables

Key variables in `variables.tf`:

| Variable | Type | Description |
|----------|------|-------------|
| `aws_region` | string | AWS region for deployment |
| `environment` | string | Environment name (dev/staging/prod) |
| `project_name` | string | Project name for resource naming |
| `vpc_cidr` | string | CIDR block for VPC |
| `instance_type` | string | EC2 instance type |

### Locals

Common local values defined in `locals.tf`:

```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }
}
```

## 📚 Usage

### Deploy Development Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### Deploy Production Environment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

### Update Infrastructure

```bash
# Edit configuration files
vim main.tf

# Review changes
terraform plan

# Apply updates
terraform apply
```

### Destroy Infrastructure

```bash
# WARNING: This will destroy all resources
terraform destroy
```

## 🔧 Modules

### Networking Module

Creates VPC, subnets, internet gateway, and routing tables.

```hcl
module "networking" {
  source = "./modules/networking"
  
  vpc_cidr        = var.vpc_cidr
  environment     = var.environment
  project_name    = var.project_name
  availability_zones = var.availability_zones
}
```

### Compute Module

Provisions EC2 instances and security groups.

```hcl
module "compute" {
  source = "./modules/compute"
  
  instance_type   = var.instance_type
  instance_count  = var.instance_count
  environment     = var.environment
  subnet_ids      = module.networking.private_subnet_ids
}
```

### Storage Module

Creates S3 buckets for data storage.

```hcl
module "storage" {
  source = "./modules/storage"
  
  bucket_name     = "${var.project_name}-${var.environment}-bucket"
  environment     = var.environment
  enable_versioning = true
}
```

## 🌍 Environments

### Development

- Small instance sizes
- Minimal redundancy
- Fast iteration
- Lower costs

**Deploy:**
```bash
cd environments/dev && terraform apply
```

### Staging

- Medium instance sizes
- Some redundancy
- Mirrors production
- Testing environment

**Deploy:**
```bash
cd environments/staging && terraform apply
```

### Production

- Large instance sizes
- Full redundancy
- High availability
- Full monitoring

**Deploy:**
```bash
cd environments/prod && terraform apply
```

## ✅ Best Practices

### 1. State Management

```bash
# Enable remote state with S3 backend
terraform {
  backend "s3" {
    bucket         = "your-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

### 2. Version Control

```bash
# .gitignore - Never commit sensitive files
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
terraform.tfvars
```

### 3. Code Organization

- Keep modules focused and single-purpose
- Use consistent naming conventions
- Document complex logic with comments

### 4. Security

- Use IAM roles instead of access keys
- Enable encryption for sensitive data
- Use security groups properly
- Enable VPC Flow Logs
- Implement least privilege access

### 5. Testing

```bash
# Validate syntax
terraform validate

# Format code
terraform fmt -recursive

# Lint with tflint (if installed)
tflint
```

### 6. Documentation

- Comment all non-obvious configurations
- Maintain this README
- Document module inputs/outputs
- Keep CHANGELOG updated

## 🔍 Troubleshooting

### Issue: "Error acquiring the state lock"

```bash
# Solution: Force unlock (use with caution)
terraform force-unlock LOCK_ID
```

### Issue: "Provider version mismatch"

```bash
# Solution: Reinitialize Terraform
rm -rf .terraform
terraform init
```

### Issue: "Resource already exists"

```bash
# Solution: Import existing resource
terraform import aws_instance.web i-1234567890abcdef0
```

### Issue: "Access Denied" errors

```bash
# Solution: Verify AWS credentials
aws sts get-caller-identity

# Check IAM permissions
aws iam get-user
```

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/new-feature`
2. Make changes and test: `terraform plan`
3. Commit changes: `git commit -m "Add new feature"`
4. Push to branch: `git push origin feature/new-feature`
5. Open a Pull Request

### Code Style

- Use 2 spaces for indentation
- Format code: `terraform fmt -recursive`
- Follow naming conventions
- Add comments for complex logic

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For issues, questions, or contributions:

- **GitHub Issues**: [Open an issue](https://github.com/Madhusudhan077/terraform-project/issues)
- **Documentation**: Check the [Terraform Docs](https://www.terraform.io/docs)
- **AWS Documentation**: [AWS Docs](https://docs.aws.amazon.com)

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/cloud-docs/recommended-practices)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

---

**Last Updated**: 2026-04-26

**Maintained by**: Madhusudhan077
