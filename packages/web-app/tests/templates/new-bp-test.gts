import { describe, expect, vi } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { click, fillIn, find, render } from '@ember/test-helpers';
import App from '#app/app.ts';
import NewBp from '#app/templates/authenticated/new-bp.gts';
import { collections } from '#app/models/collections.ts';
import type { FlashMessagesService } from 'ember-cli-flash';
import type RouterService from '@ember/routing/router-service';

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

  renderingTest('it saves new BP measurement', async ({ context }) => {
    const firebaseService = context.owner.lookup('service:firebase');
    const uidSpy = vi
      .spyOn(firebaseService, 'uid', 'get')
      .mockReturnValue('test-uid');

    const flashMessages = context.owner.lookup(
      'service:flash-messages'
    ) as FlashMessagesService;
    const flashSpy = vi.spyOn(flashMessages, 'success');

    const router = context.owner.lookup('service:router');
    const transitionToSpy = vi
      .spyOn(router, 'transitionTo')
      .mockImplementation((() =>
        Promise.resolve()) as unknown as RouterService['transitionTo']);

    const addSpy = vi.fn().mockResolvedValue({});
    const collectionsSpy = vi.spyOn(collections, 'app-users').mockReturnValue({
      bps: {
        add: addSpy,
      },
    } as unknown as ReturnType<(typeof collections)['app-users']>);

    try {
      await render(<template><NewBp /></template>);

      await fillIn('#systolic', '130');
      await fillIn('#diastolic', '90');
      await fillIn('#heartRate', '85');

      await click('button[type="submit"]');

      expect(collectionsSpy).toHaveBeenCalledWith('test-uid');
      expect(addSpy).toHaveBeenCalledWith(
        expect.objectContaining({
          systolic: 130,
          diastolic: 90,
          heartRate: 85,
          // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
          timestamp: expect.any(Date),
        })
      );
      expect(flashSpy).toHaveBeenCalledWith('BP added');
      expect(transitionToSpy).toHaveBeenCalledWith(
        'authenticated.new-measurement'
      );
    } finally {
      uidSpy.mockRestore();
      flashSpy.mockRestore();
      transitionToSpy.mockRestore();
      collectionsSpy.mockRestore();
    }
  });
});
