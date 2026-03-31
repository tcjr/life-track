import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import Component from '@glimmer/component';
import BloodDrop from '#app/icons/blood-drop.svg?component';

type PartialGlucoseMeasurement = Pick<
  GlucoseMeasurement,
  'value' | 'timestamp'
>;

interface GlucoseStatsSignature {
  Element: HTMLDivElement;
  Args: {
    glucoses: PartialGlucoseMeasurement[];
  };
}

export default class GlucoseStats extends Component<GlucoseStatsSignature> {
  get avgValue() {
    const glucoses = this.args.glucoses;
    return (
      glucoses.reduce((acc, glucose) => acc + glucose.value, 0) /
      glucoses.length
    ).toFixed(1);
  }

  <template>
    <div class="stats mb-4" ...attributes>
      <div class="stat place-items-center">
        <div class="stat-figure">
          <BloodDrop class="text-primary" />
        </div>
        <div class="stat-title">Systolic</div>
        <div class="stat-value">{{this.avgValue}}</div>
        <div class="stat-desc">{{this.args.glucoses.length}} measurements</div>
      </div>

    </div>
  </template>
}
