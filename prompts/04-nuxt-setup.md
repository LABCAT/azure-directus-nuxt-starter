# Background Agent Prompt: Nuxt Setup

## Task
Setup Nuxt 4 frontend in `apps/web/` with @directus/visual-library and SCSS/BEM.

## Context
Read `AGENTS.md`, `.cursor/rules/nuxt.mdc`, and `.cursor/rules/scss.mdc` for conventions.

## Requirements

### Initialize Nuxt
Use `pnpm dlx nuxi@latest init apps/web` or create manually with proper structure.
Nuxt 4 is the current version as of December 2025.

### Directory Structure (Nuxt 4)
```
apps/web/
├── nuxt.config.ts
├── package.json
├── tsconfig.json
├── staticwebapp.config.json
├── app/                         # Main app directory (Nuxt 4)
│   ├── app.vue
│   ├── app.config.ts
│   ├── error.vue
│   ├── assets/
│   │   └── scss/
│   │       ├── main.scss
│   │       ├── global/
│   │       │   ├── _reset.scss
│   │       │   ├── _typography.scss
│   │       │   └── _variables.scss
│   │       └── components/
│   │           └── .gitkeep
│   ├── components/
│   │   └── .gitkeep
│   ├── composables/
│   │   └── useDirectus.ts
│   ├── layouts/
│   │   └── default.vue
│   ├── middleware/
│   ├── pages/
│   │   └── index.vue
│   ├── plugins/
│   └── utils/
├── public/
│   └── favicon.ico
├── server/
└── shared/                      # Code shared between app and server
```

### package.json
Use latest versions of all packages. Example structure:

```json
{
  "name": "@app/web",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "nuxt dev",
    "build": "nuxt build",
    "generate": "nuxt generate",
    "preview": "nuxt preview",
    "lint": "eslint .",
    "typecheck": "nuxt typecheck"
  },
  "dependencies": {
    "@directus/sdk": "latest",
    "@directus/visual-library": "latest"
  },
  "devDependencies": {
    "@nuxt/eslint": "latest",
    "nuxt": "latest",
    "sass": "latest",
    "typescript": "latest"
  }
}
```

Run `pnpm add <package>@latest` to get current versions.

### nuxt.config.ts
- TypeScript strict mode
- SCSS global imports
- Directus SDK module setup
- SSR configured for Azure Static Web Apps

### Composables

#### app/composables/useDirectus.ts
```typescript
import { createDirectus, rest, authentication } from '@directus/sdk';

export function useDirectus() {
  const config = useRuntimeConfig();
  
  const client = createDirectus(config.public.directusUrl)
    .with(rest())
    .with(authentication());
  
  return client;
}
```

### SCSS Setup
- CSS custom properties in `app/assets/scss/global/_variables.scss`
- Basic reset in `app/assets/scss/global/_reset.scss`
- Typography foundations in `app/assets/scss/global/_typography.scss`
- NO SASS variables, only CSS custom properties

### Azure Static Web Apps Config
```json
{
  "navigationFallback": {
    "rewrite": "/index.html"
  },
  "routes": [],
  "platform": {
    "apiRuntime": "node:24"
  }
}
```

### Environment Variables
```env
NUXT_PUBLIC_DIRECTUS_URL=https://directus.localhost
NUXT_PUBLIC_SITE_URL=http://localhost:3000
```

## Acceptance Criteria
- [ ] `pnpm dev` runs successfully
- [ ] TypeScript strict mode enabled
- [ ] @directus/sdk configured
- [ ] @directus/visual-library installed
- [ ] SCSS with BEM structure
- [ ] Azure Static Web Apps config present
- [ ] useDirectus composable works

