import { describe, expect } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { render } from '@ember/test-helpers';

describe('Component | basic', () => {
  renderingTest('it renders dom', async ({ element }) => {
    const name = 'world';
    await render(
      <template>
        <h2>Hello {{name}}</h2>
      </template>
    );

    expect(element.textContent).toBe('Hello world');
  });
});
