import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import Component from '@glimmer/component';
import BloodDrop from '#app/icons/blood-drop.svg?component';
import { getGlucoseContextName } from '#app/utils/glucose.ts';

type PartialGlucoseMeasurement = Pick<
  GlucoseMeasurement,
  'value' | 'timestamp' | 'context'
>;

interface GlucoseStatsSignature {
  Element: HTMLDivElement;
  Args: {
    glucoses: PartialGlucoseMeasurement[];
  };
}

export default class GlucoseStats extends Component<GlucoseStatsSignature> {
  get fastingGlucoses() {
    const glucoses = this.args.glucoses.filter(
      (glucose) => glucose.context === 'fasting'
    );
    return glucoses;
  }

  get postMealGlucoses() {
    const glucoses = this.args.glucoses.filter(
      (glucose) => glucose.context === 'post-meal'
    );
    return glucoses;
  }

  get avgValue() {
    const glucoses = this.args.glucoses;
    return (
      glucoses.reduce((acc, glucose) => acc + glucose.value, 0) /
      glucoses.length
    ).toFixed(1);
  }

  get fastingAvgValue() {
    const glucoses = this.fastingGlucoses;
    return (
      glucoses.reduce((acc, glucose) => acc + glucose.value, 0) /
      glucoses.length
    ).toFixed(1);
  }

  get postMealAvgValue() {
    const glucoses = this.postMealGlucoses;
    return (
      glucoses.reduce((acc, glucose) => acc + glucose.value, 0) /
      glucoses.length
    ).toFixed(1);
  }

  <template>
    <div class="stats stats-vertical lg:stats-horizontal mb-4" ...attributes>
      <div class="stat place-items-center">
        <div class="stat-figure">
          <BloodDrop class="text-primary" />
        </div>
        <div class="stat-title">Avg. mg/dL</div>
        <div class="stat-value">{{this.avgValue}}</div>
        <div class="stat-desc">{{@glucoses.length}} measurements</div>
      </div>

      {{#if this.fastingGlucoses}}
        <div class="stat place-items-center">
          <div class="stat-figure">
            <BloodDrop class="text-primary" />
          </div>
          <div class="stat-title">{{getGlucoseContextName "fasting"}}</div>
          <div class="stat-value">{{this.fastingAvgValue}}</div>
          <div class="stat-desc">{{this.fastingGlucoses.length}}
            measurements</div>
        </div>
      {{/if}}

      {{#if this.postMealGlucoses}}
        <div class="stat place-items-center">
          <div class="stat-figure">
            <BloodDrop class="text-primary" />
          </div>
          <div class="stat-title">{{getGlucoseContextName "post-meal"}}</div>
          <div class="stat-value">{{this.postMealAvgValue}}</div>
          <div class="stat-desc">{{this.postMealGlucoses.length}}
            measurements</div>
        </div>
      {{/if}}

    </div>
  </template>
}
