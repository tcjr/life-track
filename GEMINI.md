# Project: life-track

## Project Overview

`life-track` is an Ember.js application designed to track various aspects of life, with a specific focus on "notices". It utilizes Vite for its build process and leverages Firebase for backend services, including Authentication and Firestore. The project is built with TypeScript, manages dependencies with pnpm, and incorporates Tailwind CSS with DaisyUI for a modern and responsive user interface.

## Technologies Used

*   **Framework:** Ember.js
*   **Language:** TypeScript
*   **Package Manager:** pnpm
*   **Build Tool:** Vite
*   **Styling:** Tailwind CSS, DaisyUI
*   **Backend/Database:** Firebase (Authentication, Firestore)

## Building and Running

### Prerequisites

*   Git
*   Node.js (>= 20)
*   pnpm
*   Google Chrome (recommended for development)

### Installation

1.  Clone the repository:
    ```bash
    git clone <repository-url>
    ```
2.  Navigate into the project directory:
    ```bash
    cd life-track
    ```
3.  Install dependencies:
    ```bash
    pnpm install
    ```

### Development Server

To start the development server:

```bash
pnpm start
```

Visit your application at [http://localhost:4200](http://localhost:4200).
Visit your tests at [http://localhost:4200/tests](http://localhost:4200/tests).

### Running Tests

To run the application's tests:

```bash
pnpm test
```

### Linting

To check for linting issues:

```bash
pnpm lint
```

To automatically fix linting issues:

```bash
pnpm lint:fix
```

### Building

To build the application for production:

```bash
pnpm build
```

For a development build:

```bash
pnpm vite build --mode development
```

### Firebase Emulators

To start Firebase emulators for Auth and Firestore:

```bash
pnpm start-emulators
```

The application is configured to use emulators if `VITE_USE_AUTH_EMULATOR` or `VITE_USE_FIRESTORE_EMULATOR` environment variables are set to `'true'`.

### Deploying Firestore Rules

To deploy Firestore security rules:

```bash
pnpm deploy-rules
```

## Development Conventions

*   **Code Style:** Enforced with ESLint and Prettier.
*   **Templating:** Ember Template Lint for `.hbs` and `.gts` files.
*   **Type Checking:** TypeScript with `@glint/ember-tsc`.
*   **Testing:** QUnit and Ember Test Helpers for unit and integration tests. Note: Integration tests for components interacting with Firestore may require specific setup for test data (as indicated by `TODO`s in test files).
