import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type FirebaseService from 'life-track/services/firebase';

export default class ApplicationRoute extends Route {
  @service declare firebase: FirebaseService;

  async beforeModel() {
    this.firebase.setup();
    // By awaiting authStateReady here, we guarantee the initial auth state
    // will never be in progress and `this.firebase.signedInUser` reflects the
    // true state (either null or a user);
    await this.firebase.auth.authStateReady();
  }
}
