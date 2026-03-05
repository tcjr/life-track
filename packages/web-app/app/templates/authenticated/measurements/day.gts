import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import type MeasurementDataService from '#app/services/measurement-data.ts';
import { service } from '@ember/service';
import { asLocal } from '#app/utils/dates.ts';

export interface MeasurementsDaySignature {
  Args: {
    model: {
      day: string; // YYYY-MM-DD
    };
  };
  Element: HTMLDivElement;
}

export default class MeasurementsDay extends Component<MeasurementsDaySignature> {
  @service declare measurementData: MeasurementDataService;

  get measurementsForDay() {
    const measurements =
      this.measurementData.allByDay.get(this.args.model.day) || [];
    return measurements.toSorted((a, b) => {
      return (
        a.measurement.timestamp.getTime() - b.measurement.timestamp.getTime()
      );
    });
  }

  <template>
    {{pageTitle "DAY"}}
    <div ...attributes>
      <h3 class="text-3xl font-bold text-center mb-5">(measurements for day
        {{@model.day}})</h3>
      Count:
      {{this.measurementsForDay.length}}
      <ol>
        {{#each this.measurementsForDay as |measurement|}}
          <li>
            {{asLocal measurement.measurement.timestamp}}
            [{{measurement.type}}]
            {{measurement.measurement._id}}
          </li>
        {{/each}}

      </ol>

    </div>
  </template>
}
