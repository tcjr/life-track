# Gemini CLI Context for Life Track Monorepo

This document provides an overview of the "life-track" monorepo, designed to give agents necessary context for future interactions.

## Project Overview

This is a JavaScript/TypeScript monorepo managed with `pnpm` workspaces. It contains the following main packages:

1.  **`web-app`**: An Ember.js application built with Vite and TypeScript. Its purpose is to track various aspects of the user's life, including health measurements. It integrates with Firebase for backend services (authentication, Firestore).
2.  **`functions`**: Firebase Cloud Functions providing server-side logic and API endpoints. Built with TypeScript and deployed to Firebase.
3.  **`tools`**: A collection of CLI tools for administrative tasks, data seeding, and management (e.g., adding notices, listing users, seeding measurements).

**Key Technologies:**

- **Monorepo Tooling**: pnpm workspaces
- **Frontend Framework**: Ember.js
- **Backend/Cloud Services**: Firebase (Authentication, Firestore, Cloud Functions)
- **Language**: TypeScript
- **CLI Tools**: Node.js scripts using `@clack/prompts` and `firebase-admin`
- **Build Tool**: Vite (for web-app), tsc (for functions)
- **Styling**: TailwindCSS, DaisyUI (in web-app)
- **Linting/Formatting**: ESLint, Prettier, Stylelint, Ember Template Lint
- **Testing**: Vitest (in web-app)

## Building and Running

The monorepo uses `pnpm` for script management. Commands are typically run from the root of the monorepo.

### Installation

To install dependencies for all packages:

```bash
pnpm install
```

### Local Development Environment

To start the Firebase emulators (Auth, Firestore, Functions) with imported data:

```bash
pnpm start:emulators
```

To start the development server for the `web-app` with hot-reloading:

```bash
pnpm start:web-app
# or, specifically for the web-app:
pnpm --filter=web-app run start
```

### Building Packages

To build all packages:

```bash
pnpm build
```

To build specifically for `web-app` or `functions`:

```bash
pnpm --filter=web-app run build
pnpm --filter=functions run build
```

### Running CLI Tools

CLI tools are located in `packages/tools/src`. They can be run using `node` directly.

```bash
# Example: Run the 'list-users' tool
cd packages/tools
node src/list-users.mts
```

### Running Tests

To run tests for the `web-app`:

```bash
pnpm test
# or, specifically for the web-app:
pnpm --filter=web-app run test
```

### Linting and Formatting

To run linters across all packages:

```bash
pnpm lint
```

For specific linting tasks within the `web-app`:

```bash
pnpm --filter=web-app run lint:css    # Lint CSS
pnpm --filter=web-app run lint:hbs    # Lint Ember templates
pnpm --filter=web-app run lint:js     # Lint JavaScript/TypeScript
pnpm --filter=web-app run lint:types  # Type check TypeScript files
```

### Deploying to Firebase

To deploy Firestore security rules:

```bash
pnpm deploy-rules
```

To deploy Cloud Functions:

```bash
pnpm deploy-functions
```

## Development Conventions

- **Code Style**: Enforced using ESLint and Prettier.
- **Template Style**: Enforced using Ember Template Lint.
- **CSS Style**: Enforced using Stylelint.
- **Type Safety**: TypeScript is used extensively across all packages.
- **Testing**: Unit and integration tests are primarily in `web-app` using Vitest.
