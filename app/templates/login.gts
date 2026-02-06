import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

export interface LoginSignature {
  Element: HTMLDivElement;
}

export default class Login extends Component<LoginSignature> {
  <template>
    {{pageTitle "Login"}}
    <div ...attributes>
      <h2>Login</h2>
    </div>
  </template>
}
