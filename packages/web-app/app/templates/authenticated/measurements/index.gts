import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import LoaderAndFilterer from '#app/components/measurement/loader-and-filterer.gts';

export interface IndexSignature {
  Element: HTMLDivElement;
}

export default class MeasurementsIndex extends Component<IndexSignature> {
  <template>
    {{pageTitle "Recent"}}
    <div ...attributes>

      <h3 class="text-3xl font-bold text-center mb-5">Measurements</h3>
      <LoaderAndFilterer />
    </div>
  </template>
}
