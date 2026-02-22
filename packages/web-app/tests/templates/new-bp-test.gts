import { describe, expect } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { find, render } from '@ember/test-helpers';
import App from '#app/app.ts';
import NewBp from '#app/templates/authenticated/new-bp.gts';

describe('Template | authenticated/new-bp', () => {
  renderingTest.scoped({ app: ({}, use) => use(App) });

  renderingTest('it has correct intitial values', async () => {
    await render(<template><NewBp /></template>);

    const hrInput = find('#heartRate') as HTMLInputElement;
    expect(hrInput.value).toBe('70');

    const sysInput = find('#systolic') as HTMLInputElement;
    expect(sysInput.value).toBe('120');

    const diaInput = find('#diastolic') as HTMLInputElement;
    expect(diaInput.value).toBe('80');
  });

  // TODO: Test to write:
  // - on "save" click, it calls add() on correct collection with correct data
  //   and shows "BP added" flash message
});
