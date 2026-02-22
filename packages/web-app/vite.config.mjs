import { defineConfig } from 'vite';
import { extensions, ember } from '@embroider/vite';
import { babel } from '@rollup/plugin-babel';
import tailwindcss from '@tailwindcss/vite';
import { webdriverio } from '@vitest/browser-webdriverio';

export default defineConfig({
  plugins: [
    ember(),
    tailwindcss(),
    babel({
      babelHelpers: 'runtime',
      extensions,
    }),
  ],

  test: {
    include: ['tests/**/*-test.{gjs,gts}'],
    maxConcurrency: 1,
    browser: {
      provider: webdriverio(),
      enabled: true,
      headless: true,
      instances: [
        { browser: 'chrome' }, // or 'firefox' 'edge' 'safari'
      ],
    },
  },
});
