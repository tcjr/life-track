import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import Component from '@glimmer/component';
import WeightIcon from '#app/icons/weight-scale.svg?component';

type PartialWeightMeasurement = Pick<WeightMeasurement, 'value' | 'timestamp'>;

interface WeightStatsSignature {
  Element: HTMLDivElement;
  Args: {
    weights: PartialWeightMeasurement[];
  };
}

export default class WeightStats extends Component<WeightStatsSignature> {
  get avgValue() {
    if (!this.args.weights || this.args.weights.length === 0) return '0.0';
    const weights = this.args.weights;
    return (
      weights.reduce((acc, weight) => acc + weight.value, 0) / weights.length
    ).toFixed(1);
  }

  get changeValue() {
    if (!this.args.weights || this.args.weights.length === 0) return '0.0';
    // Return the difference between the first and last values
    const first = this.args.weights?.at(0)?.value || 0;
    const last = this.args.weights?.at(-1)?.value || 0;
    console.log('first', first);
    console.log('last', last);
    const diff = last - first;
    return `${diff > 0 ? '+' : ''}${diff.toFixed(1)}`;
  }

  <template>
    <div class="stats stats-vertical lg:stats-horizontal mb-4" ...attributes>
      <div class="stat place-items-center">
        <div class="stat-figure">
          <WeightIcon class="text-primary" />
        </div>
        <div class="stat-title">Avg. lbs</div>
        <div class="stat-value">{{this.avgValue}}</div>
        <div class="stat-desc">{{@weights.length}} measurements</div>
      </div>

      <div class="stat place-items-center">
        <div class="stat-title">Change</div>
        <div class="stat-value">{{this.changeValue}}</div>
        <div class="stat-desc">&nbsp;</div>
      </div>

    </div>
  </template>
}
