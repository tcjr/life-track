import { defineConfig } from 'vite';
import { extensions, ember, optimizeDeps } from '@embroider/vite';
import { babel } from '@rollup/plugin-babel';
import tailwindcss from '@tailwindcss/vite';
import { webdriverio } from '@vitest/browser-webdriverio';
import Icons from 'unplugin-icons/vite';
import { FileSystemIconLoader } from 'unplugin-icons/loaders';

export default defineConfig({
  plugins: [
    ember(),
    tailwindcss(),
    babel({
      babelHelpers: 'runtime',
      extensions,
    }),
    Icons({
      compiler: 'ember',
      customCollections: {
        custom: FileSystemIconLoader('./app/icons'),
      },
    }),
  ],

  test: {
    optimizeDeps: {
      include: ['ember-source/@ember/template-compiler/index.js'],
    },
    include: ['tests/**/*-test.{gjs,gts}', 'tests/**/*-test.{js,ts}'],
    maxConcurrency: 1,
    browser: {
      provider: webdriverio(),
      enabled: true,
      headless: true,
      instances: [
        { browser: 'chrome' }, // or 'firefox' 'edge' 'safari'
      ],
    },
    setupFiles: ['tests/setup.ts'],
  },
});
