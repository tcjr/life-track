import { LinkTo } from '@ember/routing';
import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

interface ApplicationComponentSignature {
  Args: {
    model: unknown;
  };
}

export default class Application extends Component<ApplicationComponentSignature> {
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
            <LinkTo @route="notices">Notices</LinkTo>
          </li>
        </ul>
      </div>
    </div>

    {{outlet}}
  </template>
}
