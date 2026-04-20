import Component from '@glimmer/component';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import { asLocalTime, asISO } from '#app/utils/dates.ts';
import {
  getGlucoseContextName,
  getGlucoseQuality,
  GLUCOSE_COLORS,
} from '#app/utils/glucose.ts';
import BloodDrop from '~icons/custom/blood-drop.svg';

interface MeasurementGlucoseSignature {
  Args: {
    measurement: GlucoseMeasurement;
  };
}

const getGlucoseBg = (glucose: GlucoseMeasurement) => {
  console.log('*** glucose is', glucose);
  return GLUCOSE_COLORS[getGlucoseQuality(glucose)].bgClass;
};

export default class MeasurementGlucose extends Component<MeasurementGlucoseSignature> {
  <template>
    {{#if @measurement}}
      <article class="flex flex-row relative py-1 px-2 text-sm">
        <div class="w-1 rounded-sm mr-2 {{getGlucoseBg @measurement}}"></div>
        <div class="flex flex-col">
          <time
            class="nowrap"
            datetime={{asISO @measurement.timestamp}}
          >{{asLocalTime @measurement.timestamp}}</time>
          <h4 class="text-md">
            <BloodDrop class="inline-block align-text-bottom h-5 w-5" />
            Glucose
            {{@measurement.value}}
            ({{getGlucoseContextName @measurement.context}})
          </h4>
        </div>

      </article>
    {{/if}}
  </template>
}
