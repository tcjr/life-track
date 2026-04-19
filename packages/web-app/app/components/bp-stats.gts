import Component from '@glimmer/component';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import BloodPressure from '~icons/custom/blood-pressure.svg';
import Heart from '~icons/custom/heart.svg';

type PartialBpHrMeasurement = Pick<
  BpMeasurement,
  'systolic' | 'diastolic' | 'timestamp' | 'heartRate'
>;

interface BpStatsSignature {
  Element: HTMLDivElement;
  Args: {
    bps: PartialBpHrMeasurement[];
  };
}

export default class BpStats extends Component<BpStatsSignature> {
  get avgSystolic() {
    const bps = this.args.bps;
    return (bps.reduce((acc, bp) => acc + bp.systolic, 0) / bps.length).toFixed(
      1
    );
  }

  get avgDiastolic() {
    const bps = this.args.bps;
    return (
      bps.reduce((acc, bp) => acc + bp.diastolic, 0) / bps.length
    ).toFixed(1);
  }

  get avgHeartRate() {
    const bps = this.args.bps;
    return (
      bps.reduce((acc, bp) => acc + bp.heartRate, 0) / bps.length
    ).toFixed(1);
  }

  <template>
    <div class="stats stats-vertical lg:stats-horizontal mb-4" ...attributes>
      <div class="stat place-items-center">
        <div class="stat-figure">
          <BloodPressure class="text-primary" />
        </div>
        <div class="stat-title">Systolic</div>
        <div class="stat-value">{{this.avgSystolic}}</div>
        <div class="stat-desc">{{@bps.length}} measurements</div>
      </div>

      <div class="stat place-items-center">
        <div class="stat-figure">
          <BloodPressure class="text-secondary" />
        </div>
        <div class="stat-title">Diastolic</div>
        <div class="stat-value">{{this.avgDiastolic}}</div>
        <div class="stat-desc">{{@bps.length}} measurements</div>
      </div>

      <div class="stat place-items-center">
        <div class="stat-figure">
          <Heart class="text-base-content" />
        </div>
        <div class="stat-title">Heart Rate</div>
        <div class="stat-value">{{this.avgHeartRate}}</div>
        <div class="stat-desc">{{@bps.length}} measurements</div>
      </div>
    </div>
  </template>
}
