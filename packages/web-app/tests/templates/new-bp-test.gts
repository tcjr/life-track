import { describe, expect, vi } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { find, render, click, fillIn } from '@ember/test-helpers';
import App from '#app/app.ts';
import NewBp from '#app/templates/authenticated/new-bp.gts';
import { collections } from '#app/models/collections.ts';

describe('Template | authenticated/new-bp', () => {
  renderingTest.override('app', { scope: 'test' }, () => App);

  renderingTest('it has correct intitial values', async () => {
    await render(<template><NewBp /></template>);

    const hrInput = find('#heartRate') as HTMLInputElement;
    expect(hrInput.value).toBe('70');

    const sysInput = find('#systolic') as HTMLInputElement;
    expect(sysInput.value).toBe('120');

    const diaInput = find('#diastolic') as HTMLInputElement;
    expect(diaInput.value).toBe('80');
  });

  renderingTest(
    'on "save" click, it calls add() on correct collection with correct data and shows "BP added" flash message',
    async ({ context }) => {
      const firebase = context.owner.lookup('service:firebase');
      vi.spyOn(firebase, 'uid', 'get').mockReturnValue('test-uid');

      const flashMessages = context.owner.lookup('service:flash-messages');
      const successSpy = vi.spyOn(flashMessages, 'success');

      const router = context.owner.lookup('service:router');
      const transitionSpy = vi.spyOn(router, 'transitionTo');

      const addSpy = vi.fn().mockResolvedValue({});
      // @ts-expect-error - we are mocking the collection
      vi.spyOn(collections, 'app-users').mockReturnValue({
        bps: {
          add: addSpy,
        },
      });

      await render(
        <template>
          <NewBp />
        </template>
      );

      await fillIn('#systolic', '130');
      await fillIn('#diastolic', '85');
      await fillIn('#heartRate', '75');

      await click('button[type="submit"]');

      expect(collections['app-users']).toHaveBeenCalledWith('test-uid');
      expect(addSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          systolic: 130,
          diastolic: 85,
          heartRate: 75,
          timestamp: expect.any(Date),
        })
      );

      expect(successSpy).toHaveBeenCalledWith('BP added');
      expect(transitionSpy).toHaveBeenCalledWith(
        'authenticated.new-measurement'
      );
    }
  );
});
