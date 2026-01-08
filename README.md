# Azure Directus Nuxt Starter

Monorepo: Directus + Nuxt 3 + Terraform + Docker + GitHub Actions

## Quick Start (Local)

**Prerequisites:** Node 24+ LTS, pnpm 10+, Docker, mkcert

```bash
nvm use
pnpm install

# SSL certs (first time)
cd docker && mkcert -install && mkcert "local.labcat.nz" "local.admin.labcat.nz"

# Start Directus + PostgreSQL + Redis
docker compose -f docker/docker-compose.yml up -d

# Start Nuxt
cd apps/web && pnpm dev
```

**URLs:** Nuxt → https://local.labcat.nz | Directus → https://local.admin.labcat.nz

## Deploy Infrastructure

**Prerequisites:**

- [Terraform CLI](https://developer.hashicorp.com/terraform/install) installed
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed

### Azure Authentication

```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account list --output table
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Verify
az account show
```

### Register Resource Providers (First Time Only)

```bash
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.Web
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.Cache
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.Storage

# Check registration status
az provider show --namespace Microsoft.App --query "registrationState"
```

### Terraform Commands

```bash
cd infra
terraform init
TF_LOG=TRACE terraform plan -var-file="environments/uat.tfvars"       # Preview changes
TF_LOG=TRACE terraform apply -var-file="environments/uat.tfvars"      # UAT
TF_LOG=TRACE terraform apply -var-file="environments/production.tfvars"  # Prod
```

Secrets are stored in **Azure Key Vault** (DB password, Directus secret, storage keys, etc).

## Deploy Apps

Push to trigger GitHub Actions:

- `deploy/uat` → UAT environment
- `deploy/production` → Production environment

## Directus Schema

```bash
cd apps/directus
pnpm directus-sync pull   # Save schema
pnpm directus-sync push   # Apply schema
```

## Structure

```
apps/directus/    # Directus backend
apps/web/         # Nuxt frontend
infra/            # Terraform
docker/           # Docker Compose + Dockerfiles
.github/workflows # CI/CD
```

See `AGENTS.md` for full documentation.
