# Background Agent Prompt: Terraform Infrastructure

## Pull Request
Create a PR with your changes. The agent will automatically create a `cursor/*` branch.

**Suggested PR Title**: `feat: Add Terraform infrastructure modules`

## Task
Create Terraform modules for all Azure resources in the `infra/` directory.

## Context
Read `AGENTS.md` and `.cursor/rules/terraform.mdc` for project conventions.

## Requirements

### Directory Structure
```
infra/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
├── environments/
│   ├── uat.tfvars
│   └── production.tfvars
└── modules/
    ├── resource-group/
    ├── key-vault/
    ├── container-registry/
    ├── container-apps/
    ├── postgresql/
    ├── redis/
    ├── storage/
    └── static-web-app/
```

### Resources to Create

1. **Resource Group** - Container for all resources
2. **Azure Key Vault** - Store all secrets (DB password, Directus secret, API keys, storage keys)
3. **Azure Container Registry** - Store Directus Docker images
4. **Azure Container Apps Environment** - Serverless container hosting
5. **Azure Container App** - Directus instance (with Key Vault references for secrets)
6. **Azure Database for PostgreSQL Flexible Server** - Burstable B1ms tier
7. **Azure Cache for Redis** - Basic tier
8. **Azure Storage Account** - Blob container for Directus assets
9. **Azure Static Web Apps** - Nuxt frontend hosting

### Variables
- `environment` (uat/production)
- `location` (Azure region)
- `project_name` (resource naming prefix)
- All sensitive values (DB password, secrets) marked `sensitive = true`

### Tags
All resources must include:
```hcl
tags = {
  environment = var.environment
  project     = var.project_name
  managed_by  = "terraform"
}
```

### Outputs
- Container Registry login server
- Container App URL
- PostgreSQL connection string (sensitive)
- Redis connection string (sensitive)
- Storage account name and key (sensitive)
- Static Web App URL and API key (sensitive)

### Backend
Configure Azure Storage backend for state (commented out with instructions).

### Key Vault Secrets
Store these secrets in Key Vault:
- `db-password` - PostgreSQL password
- `directus-secret` - Directus SECRET key
- `directus-admin-password` - Initial admin password
- `storage-account-key` - Blob storage key
- `redis-password` - Redis access key

Container Apps should reference secrets via Key Vault URI.

## Acceptance Criteria
- [ ] All modules created with proper input/output variables
- [ ] Key Vault module with all required secrets
- [ ] Container App uses Key Vault references (not plaintext secrets)
- [ ] Environment-specific tfvars files
- [ ] `terraform validate` passes
- [ ] `terraform fmt` applied
- [ ] No hardcoded secrets

