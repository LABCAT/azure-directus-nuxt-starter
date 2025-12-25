# Azure Directus Nuxt Starter

Monorepo: Directus + Nuxt 3 + Terraform + Docker + GitHub Actions

## Quick Start (Local)

```bash
# Prerequisites: Node 24+ LTS, pnpm 10+, Docker, mkcert

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

```bash
cd infra
terraform init
terraform apply -var-file="environments/uat.tfvars"      # UAT
terraform apply -var-file="environments/production.tfvars"  # Prod
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

