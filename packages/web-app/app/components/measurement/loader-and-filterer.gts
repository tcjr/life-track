import Component from '@glimmer/component';
import type { BpKind, GlucoseKind, WeightKind } from './types';
import { cached, tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import Heart from '#app/icons/heart.svg?component';
import BloodPressure from '#app/icons/blood-pressure.svg?component';
import BloodDrop from '#app/icons/blood-drop.svg?component';
import WeightScale from '#app/icons/weight-scale.svg?component';
import DayList from './day-list.gts';
import { asYYYYMMDD } from '#app/utils/dates.ts';
import { service } from '@ember/service';
import { trackedObject } from '@ember/reactive/collections';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import { collections } from '#app/models/collections.ts';
import type FirebaseService from '#app/services/firebase.ts';
import type Owner from '@ember/owner';

export interface MeasurementLoaderAndFiltererSignature {
  Args: {};
  Blocks: {
    default: [
      filteredKindsByDay: Map<string, (BpKind | GlucoseKind | WeightKind)[]>,
    ];
  };
  Element: null;
}

export default class MeasurementLoaderAndFilterer extends Component<MeasurementLoaderAndFiltererSignature> {
  @service declare firebase: FirebaseService;
  @tracked includeBps = true;
  @tracked includeGlucoses = true;
  @tracked includeWeights = true;

  constructor(
    owner: Owner,
    args: MeasurementLoaderAndFiltererSignature['Args']
  ) {
    super(owner, args);
    this.loadData();
  }

  get uid() {
    return this.firebase.uid;
  }

  #measurements = trackedObject({
    bps: [] as BpMeasurement[],
    glucoses: [] as GlucoseMeasurement[],
    weights: [] as WeightMeasurement[],
  });

  loadData = async () => {
    console.log('load data');
    const DAY_IN_MS = 24 * 60 * 60 * 1000;
    const now = Date.now();
    const start = new Date(now - 60 * DAY_IN_MS);
    const end = new Date(now);

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
    this.#measurements.glucoses = glucoses;
    this.#measurements.bps = bps;
    this.#measurements.weights = weights;
  };

  /**
   * Action called for every change in the form (check/uncheck).
   */
  updatedOptions = (evt: Event) => {
    console.log('Form changes');

    evt.preventDefault();

    const formData = new FormData(evt.currentTarget as HTMLFormElement);
    const data = Object.fromEntries(formData.entries());
    this.includeBps = data.withBps === 'on';
    this.includeGlucoses = data.withGlucoses === 'on';
    this.includeWeights = data.withWeights === 'on';
  };

  /**
   * This represents all the data, flattened into a single array with a 'kind'
   * discrimanator of 'bp', 'glucose', or 'weight'.  Since it's cached, it should
   * only rebuild this when the measurements data changes.
   */
  @cached
  get allKinds() {
    console.log('COMPUTING allKinds()');
    const ms = this.#measurements;
    const all = [
      ...ms.bps.map((m) => ({ kind: 'bp', measurement: m }) as BpKind),
      ...ms.glucoses.map(
        (m) => ({ kind: 'glucose', measurement: m }) as GlucoseKind
      ),
      ...ms.weights.map(
        (m) => ({ kind: 'weight', measurement: m }) as WeightKind
      ),
    ];
    // Sort these before returning
    return all.sort(
      (a, b) =>
        a.measurement.timestamp.getTime() - b.measurement.timestamp.getTime()
    );
  }

  /**
   * Here is where we limit the array to items matching the boolean conditions.
   * This is also cached, so it will get rebuilt when any of the checkboxes cause
   * one of the booleans to change.
   */
  @cached
  get filteredKinds() {
    console.log('COMPUTING filteredKinds()');
    const kinds = this.allKinds;
    // Here, we want to only include the kinds where the checkbox is checked
    return kinds.filter((k) => {
      switch (k.kind) {
        case 'bp':
          return this.includeBps;
        case 'glucose':
          return this.includeGlucoses;
        case 'weight':
          return this.includeWeights;
      }
    });
  }

  /**
   * This groups the filtered kinds by day. It is done last so we only have keys
   * for days with a measurement.
   */
  @cached
  get filteredKindsByDay() {
    console.log('COMPUTING filteredKindsByDay()');
    const dayMap = new Map<string, (BpKind | GlucoseKind | WeightKind)[]>();
    for (const mwk of this.filteredKinds) {
      const date = asYYYYMMDD(mwk.measurement.timestamp);
      if (!dayMap.has(date)) {
        dayMap.set(date, []);
      }
      dayMap.get(date)?.push(mwk);
    }

    return dayMap;
  }

  <template>
    <div ...attributes>
      <div>
        <button class="btn" {{on "click" this.loadData}}>(refresh)</button>
      </div>

      <div data-docs="FILTERS">
        <form {{on "change" this.updatedOptions}}>
          <fieldset
            class="fieldset bg-base-100 border-base-300 rounded-box w-64 border p-4"
          >
            <legend class="fieldset-legend">Display Measurements</legend>
            <label class="label">
              <input
                type="checkbox"
                checked={{this.includeBps}}
                class="checkbox"
                name="withBps"
              />
              <span>
                <BloodPressure class="inline-block h-5" />
                BP
                <Heart class="inline-block h-5" />
                HR
              </span>
            </label>
            <label class="label">
              <input
                type="checkbox"
                checked={{this.includeGlucoses}}
                class="checkbox"
                name="withGlucoses"
              />
              <span>
                <BloodDrop class="inline-block h-5" />
                Glucose
              </span>
            </label>
            <label class="label">
              <input
                type="checkbox"
                checked={{this.includeWeights}}
                class="checkbox"
                name="withWeights"
              />
              <span>
                <WeightScale class="inline-block h-5" />
                Weight
              </span>
            </label>
          </fieldset>
        </form>

      </div>
      <div data-docs="LIST">
        <DayList @days={{this.filteredKindsByDay}} />
      </div>
    </div>
    {{yield}}
  </template>
}
