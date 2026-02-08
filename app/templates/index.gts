import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

export interface IndexSignature {
  Element: HTMLDivElement;
}

export default class Index extends Component<IndexSignature> {
  <template>
    {{pageTitle "Index"}}
    <div ...attributes>
      <h2>Index</h2>
    </div>
  </template>
}
