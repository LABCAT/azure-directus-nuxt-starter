# Background Agent Prompt: Directus Setup

## Task
Setup Directus backend in `apps/directus/` for Docker-based development with directus-sync.

## Context
Read `AGENTS.md` and `.cursor/rules/directus.mdc` for project conventions.

**Important:** Directus runs in Docker, NOT via pnpm. No package.json in this directory.

## Requirements

### Directory Structure
```
apps/directus/
├── directus-sync.config.js
├── schema/
│   └── .gitkeep
├── extensions/
│   └── .gitkeep
└── uploads/
    └── .gitkeep (gitignored contents)
```

### directus-sync Configuration
Create `directus-sync.config.js` in project root (or apps/directus/):
- Configure sync directory path
- Set up collection/field exclusions if needed
- directus-sync runs via `pnpm dlx directus-sync` from root

### Extensions
- Extensions are mounted into Docker container
- TypeScript extensions can be added to `extensions/` folder
- See Directus docs for extension development

## Acceptance Criteria
- [ ] Directory structure created
- [ ] directus-sync.config.js configured
- [ ] Extensions folder ready for mounting
- [ ] Uploads folder gitignored

