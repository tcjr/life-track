import { service } from '@ember/service';
import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import type FirebaseService from '#services/firebase';
import type RouterService from '@ember/routing/router-service';
import { action } from '@ember/object';
import FlashMessages from '#app/components/flash-messages.gts';
import Navbar from '#app/components/navbar.gts';

interface ApplicationComponentSignature {
  Args: {
    model: unknown;
  };
}

export default class Application extends Component<ApplicationComponentSignature> {
  @service declare firebase: FirebaseService;
  @service declare router: RouterService;

  @action
  async logout() {
    try {
      await this.firebase.logout();
    } catch (error) {
      console.error('Logout failed:', error);
      // TODO: Display a user-friendly error message
    } finally {
      // Redirect to login page after logout
      this.router.transitionTo('login');

      // I tried switching to a hard reload here because I haven't dealt with the timing
      // issues where the user becomes unauthenticated, but we still have some reactive
      // stuff on the page. I think it's only a problem if we have a FirestoreDocument
      // resource for the app-user model (like the settings page), but I haven't looked
      // at it closely.  Re-enable this if there are problems.

      // document.location = this.router.urlFor('login');
    }
  }

  <template>
    {{pageTitle "LifeTrack"}}

    <FlashMessages />

    <header>
      <Navbar @onLogout={{this.logout}} @user={{this.firebase.signedInUser}} />
    </header>

    <main class="container mx-auto px-4 min-h-screen">
      {{outlet}}
    </main>

    <footer
      class="footer sm:footer-horizontal footer-center bg-base-300 text-base-content/50 text-xs p-4 pb-24"
    >
      <aside>
        <p>Copyright © 2026 - tcjr</p>
      </aside>
    </footer>
  </template>
}
