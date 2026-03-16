import Component from '@glimmer/component';
import { type BpMeasurement } from '#models/measurements/bp';
import BloodPressure from '#app/icons/blood-pressure.svg?component';
import Heart from '#app/icons/heart.svg?component';

interface BpHrSignature {
  Args: {
    value: BpMeasurement;
  };
  Element: HTMLDivElement;
}

export default class BpHr extends Component<BpHrSignature> {
  <template>
    <div class="inline-block border border-base-content">
      <BloodPressure class="h-8 inline-block" />

      {{@value.systolic}}
      /
      {{@value.diastolic}}
    </div>
    -
    <div class="inline-block border border-base-content">
      <Heart class="h-8 inline-block" />

      {{@value.heartRate}}
    </div>
  </template>
}
