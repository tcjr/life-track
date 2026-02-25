import { service } from '@ember/service';
import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import type FirebaseService from '#services/firebase';
import type RouterService from '@ember/routing/router-service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import FlashMessages from '#app/components/flash-messages.gts';

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

    <div class="container mx-auto px-4">

      <div class="navbar bg-base-100 shadow-sm">
        <div class="flex-1">
          <a href="/" class="btn btn-ghost text-xl">home</a>
        </div>
        <div class="flex-none">
          <ul class="menu menu-horizontal px-1">
            {{#if this.firebase.signedInUser}}
              {{!-- <li>
                <span>{{this.firebase.signedInUser.email}}</span>
              </li> --}}
              <li>
                <a href="/settings">Settings</a>
              </li>
              <li>
                <a href="/measurements">Measurements</a>
              </li>
              <li>
                <button
                  type="button"
                  class="btn btn-ghost btn-sm"
                  {{on "click" this.logout}}
                >
                  Logout
                </button>
              </li>
            {{else}}
              <li>
                <a href="/login">Login</a>
              </li>
            {{/if}}
          </ul>
        </div>
      </div>

      {{outlet}}

      <div class="mt-96">

      </div>
    </div>
  </template>
}
