import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import BloodDrop from '#app/icons/blood-drop.svg?component';
import BloodPressure from '#app/icons/blood-pressure.svg?component';
import Nutrition from '#app/icons/nutrition.svg?component';

export interface NewMeasurementSignature {
  Element: HTMLDivElement;
}

export default class NewMeasurement extends Component<NewMeasurementSignature> {
  <template>
    {{pageTitle "New Measurement"}}
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
        <li><a class="btn btn-secondary btn-xl w-full" href="/new-meal">
            <Nutrition class="h-8" />
            Meal
          </a></li>
      </ul>
    </div>
  </template>
}
