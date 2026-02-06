import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type FirebaseService from 'life-track/services/firebase';
import type RouterService from '@ember/routing/router-service';

/**
 * If the user is not logged-in, the beforeModel hook should redirect to the
 * `login` route. This will "protect" all child routes of this one.
 */
export default class AuthenticatedRoute extends Route {
  @service declare firebase: FirebaseService;
  @service declare router: RouterService;

  async beforeModel() {
    await this.firebase.auth.authStateReady();

    if (!this.firebase.signedInUser) {
      console.log('Not logged-in, redirecting to login route');
      this.router.transitionTo('login');
    } else {
      console.log('Logged-in, current user is ', this.firebase.signedInUser);
    }
  }
}
