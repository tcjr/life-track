import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import LoaderAndFilterer from '#app/components/measurement/loader-and-filterer.gts';

export interface RecentSignature {
  Element: HTMLDivElement;
}

export default class MeasurementsRecent extends Component<RecentSignature> {
  <template>
    {{pageTitle "Recent"}}
    <div ...attributes>
      <LoaderAndFilterer />
    </div>
  </template>
}
