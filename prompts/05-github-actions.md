# Background Agent Prompt: GitHub Actions CI/CD

## Pull Request
Create a PR with your changes. The agent will automatically create a `cursor/*` branch.

**Suggested PR Title**: `feat: Add GitHub Actions CI/CD workflows`

## Task
Create GitHub Actions workflows for Directus and Nuxt deployments.

## Context
Read `AGENTS.md` for branch strategy and deployment targets.

## Requirements

### Directory Structure
```
.github/
└── workflows/
    ├── directus-deploy.yml
    ├── nuxt-deploy.yml
    └── directus-sync.yml
```

### Workflow 1: directus-deploy.yml

**Triggers:**
- Push to `deploy/uat` → deploy to UAT
- Push to `deploy/production` → deploy to Production

**Jobs:**
1. **Build**
   - Checkout code
   - Set up Docker Buildx
   - Login to Azure Container Registry
   - Build and push `directus.prod.Dockerfile`
   - Tag with commit SHA and environment

2. **Deploy**
   - Login to Azure CLI
   - Update Container App revision
   - Wait for deployment to complete

**Secrets Required:**
- `AZURE_CREDENTIALS` (service principal JSON)
- `ACR_LOGIN_SERVER`
- `ACR_USERNAME`
- `ACR_PASSWORD`
- `CONTAINER_APP_NAME_UAT`
- `CONTAINER_APP_NAME_PROD`
- `RESOURCE_GROUP`

### Workflow 2: nuxt-deploy.yml

**Triggers:**
- Push to `deploy/uat` → deploy to UAT Static Web App
- Push to `deploy/production` → deploy to Production Static Web App

**Jobs:**
1. **Build and Deploy**
   - Checkout code
   - Setup Node.js 24 LTS
   - Setup pnpm 10
   - Install dependencies
   - Build Nuxt (`pnpm build:web`)
   - Deploy using Azure Static Web Apps action

**Secrets Required:**
- `AZURE_STATIC_WEB_APPS_API_TOKEN_UAT`
- `AZURE_STATIC_WEB_APPS_API_TOKEN_PROD`

**Azure SWA Config:**
```yaml
app_location: "apps/web"
api_location: "apps/web/.output/server"
output_location: "apps/web/.output/public"
```

### Workflow 3: directus-sync.yml (Manual)

**Triggers:**
- `workflow_dispatch` with environment input

**Jobs:**
1. Run directus-sync push to selected environment

**Secrets Required:**
- `DIRECTUS_URL_UAT`
- `DIRECTUS_URL_PROD`
- `DIRECTUS_TOKEN_UAT`
- `DIRECTUS_TOKEN_PROD`

### Workflow Features
- Concurrency groups to prevent parallel deploys
- Environment protection rules (production requires approval)
- Status checks and notifications
- Artifact caching for pnpm

## Acceptance Criteria
- [ ] Workflows trigger on correct branches
- [ ] UAT and Production distinguished properly
- [ ] All secrets documented
- [ ] Workflows pass syntax validation
- [ ] Concurrency prevents race conditions

