import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

export interface SetupProfileSignature {
  Element: HTMLDivElement;
}

export default class SetupProfile extends Component<SetupProfileSignature> {
  <template>
    {{pageTitle "Setup Profile"}}
    <div ...attributes>
      <h2>Setup Profile</h2>
      <div>
        This is the onboarding page. This page will eventually have a form that
        allows the user to set some preferences, etc.
      </div>
      <div>
        For now, go into the database and update this user's app-user document
        and set the isSetup flag to true.
      </div>
    </div>
  </template>
}
