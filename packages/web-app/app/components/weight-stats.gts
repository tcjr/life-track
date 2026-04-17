import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import Component from '@glimmer/component';
import WeightIcon from '#app/icons/weight.svg?component';

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

  get minValue() {
    if (!this.args.weights || this.args.weights.length === 0) return '0.0';
    const weights = this.args.weights;
    return Math.min(...weights.map((w) => w.value)).toFixed(1);
  }

  get maxValue() {
    if (!this.args.weights || this.args.weights.length === 0) return '0.0';
    const weights = this.args.weights;
    return Math.max(...weights.map((w) => w.value)).toFixed(1);
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
        <div class="stat-figure">
          <WeightIcon class="text-info" />
        </div>
        <div class="stat-title">Min</div>
        <div class="stat-value text-info">{{this.minValue}}</div>
      </div>

      <div class="stat place-items-center">
        <div class="stat-figure">
          <WeightIcon class="text-secondary" />
        </div>
        <div class="stat-title">Max</div>
        <div class="stat-value text-secondary">{{this.maxValue}}</div>
      </div>

    </div>
  </template>
}
