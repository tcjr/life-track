import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

export interface SettingsSignature {
  Element: HTMLDivElement;
}

export default class Settings extends Component<SettingsSignature> {
  <template>
    {{pageTitle "Settings"}}
    <div ...attributes>
      <h2>Settings (authenticated)</h2>
    </div>
  </template>
}
