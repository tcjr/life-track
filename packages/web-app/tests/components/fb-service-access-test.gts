import { describe, expect, vi } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { render } from '@ember/test-helpers';
import App from '#app/app.ts';
import type { User } from 'firebase/auth';
import type FirebaseService from '#app/services/firebase.ts';
import { service } from '@ember/service';
import Component from '@glimmer/component';

// Simple component that accesses the service
class JustUid extends Component {
  @service declare firebase: FirebaseService;
  <template>The UID is {{this.firebase.uid}}.</template>
}

describe('Component | firebase service access', () => {
  // This causes the application to be loaded and instanciated, but that's it.
  renderingTest.override('app', { scope: 'test' }, () => App);

  renderingTest(
    'it renders with mocked signedInUser',
    async ({ context, element }) => {
      // The app is available, but setup() has not been called on the firebase
      // service.
      let firebaseService = context.owner.lookup('service:firebase');

      // Here we're demonstrating using a fake value for the `signedInUser`
      // that is internally used by the uid getter. The initial state is
      // restored at the end of the test.
      firebaseService.signedInUser = {
        uid: '12345',
        email: 'fakeuser@example.com',
      } as User;

      await render(<template><JustUid /></template>);

      expect(element.textContent).toBe('The UID is 12345.');

      firebaseService.signedInUser = null;
    }
  );

  renderingTest(
    'it renders with mocked uid getter',
    async ({ context, element }) => {
      let firebaseService = context.owner.lookup('service:firebase');

      // Here, we're establishing a mock for the uid getter in the service.
      // We clean this up at the end.
      const uidSpy = vi
        .spyOn(firebaseService, 'uid', 'get')
        .mockReturnValue('54321');

      await render(<template><JustUid /></template>);

      expect(element.textContent).toBe('The UID is 54321.');

      uidSpy.mockRestore();
    }
  );
});
