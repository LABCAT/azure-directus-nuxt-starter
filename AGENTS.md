# AGENTS.md

## Project Overview

Azure Directus Nuxt Starter — a monorepo containing:
- **Directus** backend (headless CMS) deployed to Azure Container Apps
- **Nuxt 3** frontend deployed to Azure Static Web Apps
- **Terraform** infrastructure-as-code for Azure
- **Docker Compose** local development with Traefik

## Monorepo Structure

```
/
├── AGENTS.md                     # This file
├── .cursor/rules/                # Cursor AI rules (scoped by file type)
├── infra/                        # Terraform modules
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
├── apps/
│   ├── directus/                 # Directus backend (runs in Docker)
│   │   ├── schema/               # Schema/config versioning (directus-sync)
│   │   └── extensions/           # Custom extensions
│   └── web/                      # Nuxt 4 frontend
│       ├── nuxt.config.ts
│       ├── package.json
│       └── app/                  # Nuxt 4 app directory
│           └── assets/scss/      # SCSS with BEM
├── docker/
│   ├── docker-compose.yml        # Local dev stack
│   ├── directus.dev.Dockerfile
│   └── directus.prod.Dockerfile
└── .github/workflows/            # CI/CD
```

## Tech Stack

| Component | Technology |
|-----------|------------|
| Frontend | Nuxt 4, TypeScript, SCSS (BEM), @directus/visual-library |
| Backend | Directus 11.5+, directus-sync |
| Database | PostgreSQL 17 (Azure Flexible Server in prod, Docker locally) |
| Cache | Redis 8 (Azure Cache in prod, Docker locally) |
| Storage | Azure Blob Storage (prod), local volume (dev) |
| Secrets | Azure Key Vault (prod) |
| Infra | Terraform, Azure Container Apps, Azure Static Web Apps |
| CI/CD | GitHub Actions |
| Local Dev | Docker Compose, Traefik (SSL), pnpm |

## Development Environment

### Prerequisites
- Node.js 24+ LTS (see `.nvmrc`)
- pnpm 10+
- Docker & Docker Compose
- mkcert (for local SSL)

### Local Setup

```bash
# Install dependencies
pnpm install

# Generate local SSL certs (first time only)
cd docker && mkcert -install && mkcert "local.labcat.nz" "local.admin.labcat.nz"

# Start backend services (Directus, PostgreSQL, Redis)
docker compose -f docker/docker-compose.yml up -d

# Start Nuxt dev server
cd apps/web && pnpm dev
```

### URLs (Local)
- Nuxt: https://local.labcat.nz
- Directus: https://local.admin.labcat.nz
- Traefik Dashboard: http://localhost:8080

## Build Commands

### Nuxt
```bash
cd apps/web
pnpm dev          # Development server
pnpm build        # Production build
pnpm generate     # Static generation
pnpm lint         # ESLint
pnpm typecheck    # TypeScript check
```

### Directus
```bash
cd apps/directus
pnpm directus-sync pull    # Pull schema from running instance
pnpm directus-sync push    # Push schema to running instance
pnpm directus-sync diff    # Show schema differences
```

Note: Directus runs in Docker, not pnpm. directus-sync runs via `pnpm dlx`.

### Terraform
```bash
cd infra
terraform init
terraform plan -var-file="environments/uat.tfvars"
terraform apply -var-file="environments/uat.tfvars"
```

### Docker
```bash
# Local development
docker compose -f docker/docker-compose.yml up -d
docker compose -f docker/docker-compose.yml down

# Build prod image
docker build -f docker/directus.prod.Dockerfile -t directus-prod apps/directus
```

## Coding Conventions

### TypeScript
- Strict mode enabled
- Explicit return types on functions
- Prefer `interface` over `type` for object shapes
- No `any` — use `unknown` and narrow

### SCSS/BEM
- Strict BEM naming: `.block__element--modifier`
- No SASS variables — use CSS custom properties
- One component per file in `assets/scss/components/`
- Global styles in `assets/scss/global/`

### File Naming
- Components: PascalCase (`UserCard.vue`)
- Composables: camelCase with `use` prefix (`useAuth.ts`)
- Utils: camelCase (`formatDate.ts`)
- SCSS: kebab-case (`_user-card.scss`)

### Comments
- Avoid inline comments — code should be self-documenting
- Use JSDoc/TSDoc for public APIs only
- No TODO comments in committed code

### Documentation
- **README.md must be extremely concise** — only critical info needed to work on the project
- Detailed documentation belongs in AGENTS.md
- Prefer bullet points and code blocks over verbose explanations

## Environments

| Environment | Directus | Nuxt | Database |
|-------------|----------|------|----------|
| Local | Docker (Traefik) | pnpm dev | Docker PostgreSQL |
| UAT | Azure Container Apps | Azure Static Web Apps | Azure PostgreSQL |
| Production | Azure Container Apps | Azure Static Web Apps | Azure PostgreSQL |

## CI/CD

### Branch Strategy
- `main` — protected, requires PR
- `deploy/uat` — triggers UAT deployment
- `deploy/production` — triggers Production deployment
- `feature/*` — development branches

### Workflows
1. **directus-deploy.yml** — Build Docker image, push to ACR, deploy to Container Apps
2. **nuxt-deploy.yml** — Build Nuxt, deploy to Static Web Apps
3. **directus-sync.yml** — Sync Directus schema between environments

## Environment Variables

### Directus (Local Dev)
```env
DB_CLIENT=pg
DB_HOST=postgres
DB_PORT=5432
DB_DATABASE=directus
DB_USER=directus
DB_PASSWORD=localdevpassword
REDIS_HOST=redis
REDIS_PORT=6379
STORAGE_LOCATIONS=local
SECRET=local-dev-secret
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=localdevpassword
```

### Directus (Production)
In production, secrets are stored in **Azure Key Vault** and referenced by Container Apps:
- `db-password`, `directus-secret`, `directus-admin-password`, `storage-account-key`, `redis-password`

### Nuxt
```env
NUXT_PUBLIC_DIRECTUS_URL=
NUXT_PUBLIC_SITE_URL=
```

## Pull Request Guidelines

1. Branch from `main`, target `main`
2. Run `pnpm lint` and `pnpm typecheck` before committing
3. Include clear description of changes
4. Reference related issues
5. Ensure CI passes before requesting review

## Troubleshooting

### Docker
- If Traefik can't bind ports: check for conflicting services on 80/443
- If Directus can't connect to DB: ensure PostgreSQL container is healthy

### Directus Sync
- Always pull before making schema changes in UI
- Commit sync files with schema changes

### Nuxt
- Clear `.nuxt` and `node_modules/.cache` if HMR breaks
- Run `pnpm nuxi cleanup` for full reset

