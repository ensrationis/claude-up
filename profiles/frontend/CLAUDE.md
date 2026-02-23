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
- TODO: e.g. CORS on local dev, hydration mismatch with SSR, wallet popup blocked by browser, env var prefix (VITE_ / NEXT_PUBLIC_)

## Rules
- NEVER inline styles — use design system / Tailwind classes
- NEVER use barrel exports (index.ts re-exporting everything) — they break tree-shaking
- Don't add npm packages without checking existing deps in package.json first
