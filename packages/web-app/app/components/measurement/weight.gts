import Component from '@glimmer/component';
import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import { asLocalTime, asISO } from '#app/utils/dates.ts';
import { getWeightQuality, WEIGHT_COLORS } from '#app/utils/weight.ts';
import WeightScale from '#app/icons/weight-scale.svg?component';

interface MeasurementWeightSignature {
  Args: {
    measurement: WeightMeasurement;
  };
  Element: HTMLDivElement;
}

const getWeightBg = (weight: WeightMeasurement) =>
  WEIGHT_COLORS[getWeightQuality(weight)].bgClass;

export default class MeasurementWeight extends Component<MeasurementWeightSignature> {
  <template>
    {{#if @measurement}}
      <article class="flex flex-row relative py-1 px-2 text-sm" ...attributes>
        <div class="w-1 rounded-sm mr-2 {{getWeightBg @measurement}}"></div>
        <div class="flex flex-col">
          <time
            class="nowrap"
            datetime={{asISO @measurement.timestamp}}
          >{{asLocalTime @measurement.timestamp}}</time>
          <h4 class="text-md">
            <WeightScale class="inline-block h-5 w-5" />
            Weight
            {{@measurement.value}}
          </h4>
        </div>
      </article>
    {{/if}}
  </template>
}
