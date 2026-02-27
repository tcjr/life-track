import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

export interface NewMeasurementSignature {
  Element: HTMLDivElement;
}

export default class NewMeasurement extends Component<NewMeasurementSignature> {
  <template>
    {{pageTitle "New Measurement"}}
    <div ...attributes>
      <h3 class="text-3xl font-bold text-center mb-5">What do you want to track?</h3>
      <ul class="flex flex-col gap-4">
        <li><a class="btn btn-secondary btn-xl w-full" href="/new-bp">Blood
            Pressure &amp; Heart Rate</a></li>
        <li><a
            class="btn btn-secondary btn-xl w-full"
            href="/new-glucose"
          >Glucose</a></li>
        <li><a
            class="btn btn-secondary btn-xl w-full"
            href="/new-meal"
          >Meal</a></li>
      </ul>
    </div>
  </template>
}
