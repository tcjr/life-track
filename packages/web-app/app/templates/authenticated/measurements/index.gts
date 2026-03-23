import MonthList from '#app/components/month-list.gts';
import Component from '@glimmer/component';
import '@event-calendar/core/index.css';
import { pageTitle } from 'ember-page-title';
import type MeasurementDataService from '#app/services/measurement-data.ts';
import { service } from '@ember/service';

export interface IndexSignature {
  Element: HTMLDivElement;
}

export default class MeasurementsIndex extends Component<IndexSignature> {
  @service declare measurementData: MeasurementDataService;

  <template>
    {{pageTitle "Monthly"}}
    <div ...attributes>

      <h3 class="text-3xl font-bold text-center mb-5">Measurements</h3>
      <MonthList @measurements={{this.measurementData.allMeasurements}} />
    </div>
  </template>
}
