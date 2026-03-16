import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import type MeasurementDataService from '#app/services/measurement-data.ts';
import { service } from '@ember/service';
import { asLocalTime } from '#app/utils/dates.ts';
import BpHr from '#app/components/measurements/bp-hr.gts';
import type { MeasurementValue } from '#app/services/measurement-data.ts';
import Glucose from '#app/components/measurements/glucose.gts';

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

  getMeasurementView = (measurement: MeasurementValue) => {
    if (measurement.type === 'bp') {
      return BpHr;
    } else if (measurement.type === 'glucose') {
      return Glucose;
    }
  };

  <template>
    {{pageTitle "DAY"}}
    <div ...attributes>
      <h3 class="text-3xl font-bold text-center mb-5">(measurements for day
        {{@model.day}})</h3>
      Count:
      {{this.measurementsForDay.length}}
      <ol>
        {{#each this.measurementsForDay as |measurement|}}
          <li
            data-measurement-type={{measurement.type}}
            data-measurement-id={{measurement.measurement._id}}
          >
            {{!asLocal measurement.measurement.timestamp}}
            {{asLocalTime measurement.measurement.timestamp}}
            {{#let (this.getMeasurementView measurement) as |MV|}}
              <MV @value={{measurement.measurement}} />
            {{/let}}
          </li>
        {{/each}}
      </ol>

    </div>
  </template>
}
