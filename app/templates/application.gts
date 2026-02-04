import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

interface ApplicationComponentSignature {
  Args: {
    model: {
      notices: Array<{ text: string }>;
    };
  };
}

export default class Application extends Component<ApplicationComponentSignature> {
  <template>
    {{pageTitle "LifeTrack"}}
    <h2 class="bg-primary text-primary-content">Welcome to Ember</h2>

    {{#each @model.notices as |notice|}}
      NOTICE:
      {{notice.text}}
    {{/each}}

    {{outlet}}
  </template>
}
