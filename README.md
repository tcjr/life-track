# Life Track

A personal life tracking application built with Ember.js, Firebase, and modern web technologies. Track various aspects of your life including health measurements and more.

## Overview

Life Track is a monorepo containing:

- **web-app**: An Ember.js application for tracking life metrics
- **emulators**: Firebase emulators for local development

## Tech Stack

- **Frontend**: Ember.js with Vite
- **Language**: TypeScript
- **Backend**: Firebase (Authentication, Firestore)
- **Styling**: TailwindCSS, DaisyUI
- **Testing**: Vitest
- **Package Manager**: pnpm

## Prerequisites

- Node.js 20+
- pnpm
- Google Chrome (for testing)

## Installation

```bash
pnpm install
```

## Development

### Start Development Server

```bash
pnpm start
```

This starts both the web-app and emulators. The web app runs at http://localhost:4200.

### Run Tests

```bash
pnpm test
```

### Build for Production

```bash
pnpm build
```

### Linting

```bash
pnpm lint          # Run all linters
pnpm lint:fix      # Fix linting issues
```

For package-specific linting:

```bash
pnpm --filter=web-app run lint:css    # Lint CSS
pnpm --filter=web-app run lint:hbs    # Lint Ember templates
pnpm --filter=web-app run lint:js     # Lint JavaScript/TypeScript
pnpm --filter=web-app run lint:types  # Type check TypeScript
```

### Firebase Emulators

The emulators package provides local Firebase services:

```bash
pnpm --filter=emulators start
```

This starts Auth and Firestore emulators with pre-loaded dev data.

### Deploy Firestore Rules

```bash
pnpm deploy-rules
```

## Project Structure

```
life-track/
├── packages/
│   ├── web-app/          # Ember.js application
│   │   ├── app/          # Application code
│   │   ├── tests/        # Test files
│   │   └── ...
│   └── emulators/       # Firebase emulator data
├── firestore.rules      # Firestore security rules
├── firestore.indexes.json
└── firebase.json
```

## Further Reading

- [Ember.js](https://emberjs.com/)
- [Vite](https://vite.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [TailwindCSS](https://tailwindcss.com/)
