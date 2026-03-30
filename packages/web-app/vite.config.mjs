import { defineConfig } from 'vite';
import { extensions, ember } from '@embroider/vite';
import { babel } from '@rollup/plugin-babel';
import tailwindcss from '@tailwindcss/vite';
import { webdriverio } from '@vitest/browser-webdriverio';
import svg2ember from 'svg2ember/vite';

export default defineConfig({
  plugins: [
    svg2ember(),
    ember(),
    tailwindcss(),
    babel({
      babelHelpers: 'runtime',
      extensions,
    }),
  ],

  test: {
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
