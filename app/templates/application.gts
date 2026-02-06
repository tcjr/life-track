import { LinkTo } from '@ember/routing';
import { service } from '@ember/service';
import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import type FirebaseService from 'life-track/services/firebase';
import type RouterService from '@ember/routing/router-service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

interface ApplicationComponentSignature {
  Args: {
    model: unknown;
  };
}

export default class Application extends Component<ApplicationComponentSignature> {
  @service declare firebase: FirebaseService;
  @service declare router: RouterService; // Inject router service

  @action
  async logout() {
    try {
      await this.firebase.logout();
      this.router.transitionTo('login'); // Redirect to login page after logout
    } catch (error) {
      console.error('Logout failed:', error);
      // TODO: Display a user-friendly error message
    }
  }

  <template>
    {{pageTitle "LifeTrack"}}
    <h2 class="bg-primary text-primary-content">Welcome to Ember</h2>

    <div class="navbar bg-base-100 shadow-sm">
      <div class="flex-1">
        <LinkTo @route="index" class="btn btn-ghost text-xl">LT</LinkTo>
      </div>
      <div class="flex-none">
        <ul class="menu menu-horizontal px-1">
          {{#if this.firebase.signedInUser}}
            <li>
              <span>{{this.firebase.signedInUser.email}}</span>
            </li>
            <li>
              <LinkTo @route="authenticated.settings">Settings</LinkTo>
            </li>
            <li>
              <LinkTo @route="authenticated.notices">Notices</LinkTo>
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
              <LinkTo @route="login">Login</LinkTo>
            </li>
          {{/if}}
        </ul>
      </div>
    </div>

    {{outlet}}
    <div class="mt-20">
      <hr />
      <pre>Signed-in user: {{JSON.stringify
          this.firebase.signedInUser
          null
          2
        }}</pre>

    </div>
  </template>
}
