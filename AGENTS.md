# Gemini CLI Context for Life Track Monorepo

This document provides an overview of the "life-track" monorepo, designed to give agents necessary context for future interactions.

## Project Overview

This is a JavaScript/TypeScript monorepo managed with `pnpm` workspaces. It currently contains two main packages:

1.  **`web-app`**: An Ember.js application built with Vite and TypeScript. Its purpose is to track various aspects of the user's life, including health measurements, based on the `app/models` and `app/templates` directories. It integrates with Firebase for backend services (authentication, Firestore).

**Key Technologies:**

- **Monorepo Tooling**: pnpm workspaces
- **Frontend Framework**: Ember.js
- **Build Tool**: Vite
- **Language**: TypeScript
- **Backend/Cloud Services**: Firebase (Authentication, Firestore)
- **Styling**: TailwindCSS, DaisyUI
- **Linting/Formatting**: ESLint, Prettier, Stylelint, Ember Template Lint
- **Testing**: Vitest

## Building and Running

The monorepo uses `pnpm` for script management. Commands are typically run from the root of the monorepo.

### Installation

To install dependencies for all packages:

```bash
pnpm install
```

### Building the `web-app`

To build the Ember.js `web-app` for production:

```bash
pnpm build
# or, specifically for the web-app:
pnpm --filter=web-app run build
```

### Starting the `web-app` Development Server

To start the development server for the `web-app` with hot-reloading:

```bash
pnpm start:web-app
# or, specifically for the web-app:
pnpm --filter=web-app run start
```

### Running Tests

To run tests for the `web-app`:

```bash
pnpm test
# or, specifically for the web-app:
pnpm --filter=web-app run test
```

### Linting and Formatting

To run linters and formatters across all packages:

```bash
pnpm lint
pnpm format
```

For specific linting tasks within the `web-app`:

```bash
pnpm --filter=web-app run lint:css    # Lint CSS
pnpm --filter=web-app run lint:hbs    # Lint Ember templates
pnpm --filter=web-app run lint:js     # Lint JavaScript/TypeScript
pnpm --filter=web-app run lint:types  # Type check TypeScript files
```

To fix linting and formatting issues:

```bash
pnpm --filter=web-app run lint:fix
```

### Deploying Firestore Rules

To deploy Firestore security rules:

```bash
pnpm deploy-rules
```

## Development Conventions

- **Code Style**: Enforced using ESLint and Prettier.
- **Template Style**: Enforced using Ember Template Lint.
- **CSS Style**: Enforced using Stylelint.
- **Type Safety**: TypeScript is used extensively, with type checking performed via `ember-tsc`.
- **Testing**: Unit and integration tests are written using Vitest and Ember's testing utilities.
