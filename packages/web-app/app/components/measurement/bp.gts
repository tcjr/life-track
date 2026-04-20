import Component from '@glimmer/component';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import { asLocalTime, asISO } from '#app/utils/dates.ts';
import { getBpQuality, BP_COLORS } from '#app/utils/bp.ts';
import Heart from '~icons/custom/heart.svg';
import BloodPressure from '~icons/custom/blood-pressure.svg';

interface MeasurementBpSignature {
  Args: {
    measurement: BpMeasurement;
  };
}

const getBpBg = (bp: BpMeasurement) => BP_COLORS[getBpQuality(bp)].bgClass;

export default class MeasurementBp extends Component<MeasurementBpSignature> {
  <template>
    {{#if @measurement}}
      <article class="flex flex-row relative py-1 px-2 text-sm">
        <div class="w-1 rounded-sm mr-2 {{getBpBg @measurement}}"></div>
        <div class="flex flex-col">
          <time
            class="nowrap"
            datetime={{asISO @measurement.timestamp}}
          >{{asLocalTime @measurement.timestamp}}</time>
          <h4 class="text-md">
            <BloodPressure class="inline-block h-5 w-5" />
            BP
            {{@measurement.systolic}}/{{@measurement.diastolic}},
            <Heart class="inline-block h-5 w-5" />
            HR
            {{@measurement.heartRate}}
          </h4>
        </div>

      </article>
    {{/if}}
  </template>
}
