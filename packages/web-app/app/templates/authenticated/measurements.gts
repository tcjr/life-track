import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

export interface MeasurementsSignature {
  Args: { model: unknown };
  Element: HTMLDivElement;
}

export default class Measurements extends Component<MeasurementsSignature> {
  <template>
    {{pageTitle "Measurements"}}
    {{outlet}}
  </template>
}
