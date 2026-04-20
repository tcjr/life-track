import Component from '@glimmer/component';
import '@event-calendar/core/index.css';
import { pageTitle } from 'ember-page-title';
import type MeasurementDataService from '#app/services/measurement-data.ts';
import { service } from '@ember/service';
import MonthList from '#app/components/month-list.gts';
import RangeList from '#app/components/measurement/range-list.gts';
import { collections } from '#app/models/collections.ts';
import type FirebaseService from '#app/services/firebase.ts';
import { on } from '@ember/modifier';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import { trackedObject } from '@ember/reactive/collections';

export interface RecentSignature {
  Element: HTMLDivElement;
}

export default class MeasurementsRecent extends Component<RecentSignature> {
  @service declare firebase: FirebaseService;

  get uid() {
    return this.firebase.uid;
  }

  _measurements = trackedObject({
    bps: [] as BpMeasurement[],
    glucoses: [] as GlucoseMeasurement[],
    weights: [] as WeightMeasurement[],
  });

  loadData = async () => {
    console.log('load data');
    const DAY_IN_MS = 24 * 60 * 60 * 1000;
    const _now = Date.now();
    const start = new Date(_now - 60 * DAY_IN_MS);
    const end = new Date(_now);

    const queryPieces = {
      limit: 100, // dev safeguard, DELETE THIS
      where: [
        ['timestamp', '>=', start] as ['timestamp', '>=', Date],
        ['timestamp', '<=', end] as ['timestamp', '<=', Date],
      ],
      orderBy: [['timestamp', 'asc'] as ['timestamp', 'asc']],
    };

    const glucosesPromise = collections['app-users'](
      this.uid
    ).glucoses.findMany({
      name: 'recent-glucoses',
      ...queryPieces,
    });

    const bpsPromise = collections['app-users'](this.uid).bps.findMany({
      name: 'recent-bps',
      ...queryPieces,
    });

    const weightsPromise = collections['app-users'](this.uid).weights.findMany({
      name: 'recent-weights',
      ...queryPieces,
    });

    const [glucoses, bps, weights] = await Promise.all([
      glucosesPromise,
      bpsPromise,
      weightsPromise,
    ]);
    console.log(`Loaded ${glucoses.length} glucoses: `, glucoses);
    console.log(`Loaded ${weights.length} weights: `, weights);
    console.log(`Loaded ${bps.length} bps: `, bps);
    this._measurements.glucoses = glucoses;
    this._measurements.bps = bps;
    this._measurements.weights = weights;
  };

  <template>
    {{pageTitle "Recent"}}
    <div ...attributes>

      <button class="btn" {{on "click" this.loadData}}>Get Data</button>
      <RangeList @measurements={{this._measurements}} />
    </div>
  </template>
}
