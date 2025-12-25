# Background Agent Prompt: Docker Local Development

## Pull Request
Create a PR with your changes. The agent will automatically create a `cursor/*` branch.

**Suggested PR Title**: `feat: Add Docker Compose local development setup`

## Task
Create Docker Compose setup for local development in the `docker/` directory.

## Context
Read `AGENTS.md` and `.cursor/rules/directus.mdc` for project conventions.

## Requirements

### Directory Structure
```
docker/
├── docker-compose.yml
├── directus.dev.Dockerfile
├── directus.prod.Dockerfile
├── traefik/
│   └── traefik.yml
└── README.md
```

### Services

Use latest stable versions of all images.

#### 1. Traefik (Reverse Proxy)
- Image: `traefik:latest` (or latest v3.x)
- Ports: 80, 443, 8080 (dashboard)
- SSL via mkcert certificates (mounted from `docker/certs/`)
- Labels for routing

#### 2. PostgreSQL
- Image: `postgres:17-alpine`
- Port: 5432
- Volume: `postgres_data`
- Environment: `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`

#### 3. Redis
- Image: `redis:8-alpine`
- Port: 6379
- Volume: `redis_data`

#### 4. Directus
- Build from `Dockerfile.dev`
- Depends on: postgres, redis
- Volume mounts for hot reload:
  - `../apps/directus/extensions:/directus/extensions`
  - `../apps/directus/uploads:/directus/uploads`
- Traefik labels for `local.admin.labcat.nz`

### Dockerfiles

#### directus.dev.Dockerfile
- Base: `directus/directus:latest` (latest stable)
- Install dev dependencies
- Volume mounts for extensions

#### directus.prod.Dockerfile
- Multi-stage build
- Base: `directus/directus:latest` (latest stable)
- Copy built extensions
- No dev dependencies
- Minimal final image

### Environment
Create `.env.example` in `docker/` with all required variables.

### URLs
- Nuxt: https://local.labcat.nz
- Directus: https://local.admin.labcat.nz
- Traefik Dashboard: http://localhost:8080

### Hosts File
Users must add to `/etc/hosts`:
```
127.0.0.1 local.labcat.nz local.admin.labcat.nz
```

## Acceptance Criteria
- [ ] `docker compose up -d` starts all services
- [ ] Directus accessible at https://directus.localhost
- [ ] PostgreSQL and Redis healthy
- [ ] Hot reload works for extensions
- [ ] README with setup instructions (mkcert, etc.)

