import Component from '@glimmer/component';
// import { pageTitle } from 'ember-page-title';
import type MeasurementDataService from '#app/services/measurement-data.ts';
import { service } from '@ember/service';

export interface IndexSignature {
  Element: HTMLDivElement;
}

export default class MeasurementsIndex extends Component<IndexSignature> {
  @service declare measurementData: MeasurementDataService;

  <template>
    {{!pageTitle "Measurements"}}
    {{!log "consumed measurements data" this.measurementsData}}
    <div ...attributes>
      <h3 class="text-3xl font-bold text-center mb-5">(measurements index)</h3>
      <div>
        You have
        {{this.measurementData.allMeasurements.bps.length}}
        bps.
        <br />
        You have
        {{this.measurementData.allMeasurements.glucoses.length}}
        glucoses.
      </div>

      <ol>
        {{#each-in this.measurementData.allByDay as |day|}}
          <li><a href="/measurements/day/{{day}}" class="link">{{day}}</a></li>
        {{/each-in}}
      </ol>

    </div>
  </template>
}
