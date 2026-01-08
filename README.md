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
- **Azure Pay-As-You-Go subscription** (required for multiple environments)

### Azure Subscription Requirements

Free/trial Azure subscriptions have strict quotas that limit infrastructure deployment:

| Resource | Free Tier Limit | Pay-As-You-Go |
|----------|-----------------|---------------|
| Container App Environments | 1 total | 5+ per region |
| PostgreSQL Flexible Servers | Limited | Standard |
| Redis Cache | Limited | Standard |

**To deploy both UAT and Production**, upgrade to Pay-As-You-Go or request quota increases via Azure Portal → Subscriptions → Usage + Quotas.

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

Each environment uses a separate **workspace** to isolate state files:

```bash
cd infra
terraform init

# UAT Environment
terraform workspace new uat        # First time only
terraform workspace select uat
TF_LOG=INFO terraform plan -var-file="environments/uat.tfvars"
TF_LOG=INFO terraform apply -var-file="environments/uat.tfvars"

# Production Environment
terraform workspace new production  # First time only
terraform workspace select production
TF_LOG=INFO terraform plan -var-file="environments/production.tfvars"
TF_LOG=INFO terraform apply -var-file="environments/production.tfvars"

# List/check current workspace
terraform workspace list
terraform workspace show
```

**Logging levels:** `TF_LOG=INFO` (recommended), `TF_LOG=DEBUG` (more detail), `TF_LOG=TRACE` (very verbose)

**Important:** Always ensure you're in the correct workspace before running apply!

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
