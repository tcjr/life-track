import Component from '@glimmer/component';
import { type GlucoseMeasurement } from '#models/measurements/glucose';
import BloodDrop from '#app/icons/blood-drop.svg?component';

interface GlucoseSignature {
  Args: {
    value: GlucoseMeasurement;
  };
  Element: HTMLDivElement;
}

export default class Glucose extends Component<GlucoseSignature> {
  <template>
    <div class="inline-block border border-base-content">
      <BloodDrop class="h-8 inline-block" />
      {{@value.value}}
    </div>
  </template>
}
