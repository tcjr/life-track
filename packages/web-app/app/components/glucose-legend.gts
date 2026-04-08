import Component from '@glimmer/component';
import {
  getGlucoseContextName,
  getGlucoseQuality,
  GLUCOSE_STATUS_CLASSES,
} from '#app/utils/glucose.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';

export interface GlucoseLegendSignature {
  Element: null;
}

const fastingGlucoses: GM[] = [];
for (let i = 50; i <= 300; i++) {
  fastingGlucoses.push({ value: i, context: 'fasting' });
}

const postMealGlucoses: GM[] = [];
for (let i = 50; i <= 300; i++) {
  postMealGlucoses.push({ value: i, context: 'post-meal' });
}

const otherGlucoses: GM[] = [];
for (let i = 50; i <= 300; i++) {
  otherGlucoses.push({ value: i, context: 'other' });
}

type GM = Pick<GlucoseMeasurement, 'value' | 'context'>;

const glucoseStatus = (glucose: GM) =>
  GLUCOSE_STATUS_CLASSES[getGlucoseQuality(glucose)];

/**
 * This component is for debugging.
 */
export default class GlucoseLegend extends Component<GlucoseLegendSignature> {
  <template>
    <div>Glucose: {{getGlucoseContextName "fasting"}}</div>
    <ul>
      {{#each fastingGlucoses as |g|}}
        <li class="inline-block px-2">
          <div aria-label="status" class="status {{glucoseStatus g}}"></div>
          {{g.value}}
        </li>
      {{/each}}
    </ul>

    <div>Glucose: {{getGlucoseContextName "post-meal"}}</div>
    <ul>
      {{#each postMealGlucoses as |g|}}
        <li class="inline-block px-2">
          <div aria-label="status" class="status {{glucoseStatus g}}"></div>
          {{g.value}}
        </li>
      {{/each}}
    </ul>

    <div>Glucose: {{getGlucoseContextName "other"}}</div>
    <ul>
      {{#each otherGlucoses as |g|}}
        <li class="inline-block px-2">
          <div aria-label="status" class="status {{glucoseStatus g}}"></div>
          {{g.value}}
        </li>
      {{/each}}
    </ul>
  </template>
}
