import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import BloodDrop from '~icons/custom/blood-drop.svg';
import BloodPressure from '~icons/custom/blood-pressure.svg';
import Weight from '~icons/custom/weight-scale.svg';

export interface NewMeasurementSignature {
  Element: HTMLDivElement;
}

export default class NewMeasurement extends Component<NewMeasurementSignature> {
  <template>
    {{pageTitle "Track Something"}}
    <div ...attributes>
      <h3 class="text-3xl font-bold text-center mb-5">What do you want to track?</h3>
      <ul class="flex flex-col gap-4">
        <li><a class="btn btn-secondary btn-xl w-full" href="/new-bp">
            <BloodPressure class="h-8" />
            Blood Pressure
          </a></li>
        <li>
          <a class="btn btn-secondary btn-xl w-full" href="/new-glucose">
            <BloodDrop class="h-8" />
            Glucose
          </a></li>
        <li>
          <a class="btn btn-secondary btn-xl w-full" href="/new-weight">
            <Weight class="h-8" />
            Weight
          </a></li>
      </ul>
    </div>
  </template>
}
