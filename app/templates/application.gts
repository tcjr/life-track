import { LinkTo } from '@ember/routing';
import { service } from '@ember/service';
import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import type FirebaseService from 'life-track/services/firebase';

interface ApplicationComponentSignature {
  Args: {
    model: unknown;
  };
}

export default class Application extends Component<ApplicationComponentSignature> {
  @service declare firebase: FirebaseService;

  <template>
    {{pageTitle "LifeTrack"}}
    <h2 class="bg-primary text-primary-content">Welcome to Ember</h2>

    <div class="navbar bg-base-100 shadow-sm">
      <div class="flex-1">
        <LinkTo @route="index" class="btn btn-ghost text-xl">LT</LinkTo>
      </div>
      <div class="flex-none">
        <ul class="menu menu-horizontal px-1">
          <li>
            <LinkTo @route="login">Login</LinkTo>
          </li>
          <li>
            <LinkTo @route="authenticated.settings">Settings</LinkTo>
          </li>
          <li>
            <LinkTo @route="authenticated.notices">Notices</LinkTo>
          </li>
        </ul>
      </div>
    </div>

    {{outlet}}
    <div class="mt-20">
      <hr />
      <pre>Signed-in user: {{JSON.stringify this.firebase.signedInUser}}</pre>

    </div>
  </template>
}
