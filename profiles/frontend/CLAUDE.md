# Project: TODO_PROJECT_NAME

TODO_DESCRIPTION. Web application / dApp.

## Architecture
- src/components/  — UI components
- src/views/       — page-level components
- src/api/         — backend/chain interaction
- src/store/       — state management
- public/          — static assets

## Commands
- Dev server: TODO (e.g. `yarn dev`)
- Build: TODO (e.g. `yarn build`)
- Lint: TODO (e.g. `yarn lint`)
- Test single: TODO (e.g. `yarn test -- --grep "test name"`)
- Test all: TODO (e.g. `yarn test`)
- Type check: TODO (e.g. `yarn typecheck`)

## Testing
- Framework: TODO (Vitest / Jest / Cypress)
- Run lint + typecheck after every change
- New components require tests
- Run `yarn build` before committing to catch type errors

## Code Style
- TODO: component naming, file naming, state management patterns
- Web3: TODO (ethers.js / @polkadot/api patterns)

## Gotchas
- TODO: project-specific pitfalls (e.g. wallet connection edge cases, SSR hydration, env vars prefix)

## Rules
- NEVER commit node_modules/ or dist/ — they are in .gitignore
- NEVER use `any` type in TypeScript — use `unknown` and narrow
- NEVER inline styles — use design system / Tailwind classes
- Don't add npm packages without checking existing deps in package.json first
