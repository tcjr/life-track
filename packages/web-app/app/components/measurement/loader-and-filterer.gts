import Component from '@glimmer/component';
import type { BpKind, GlucoseKind, WeightKind } from './types';
import { cached, tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import Heart from '#app/icons/heart.svg?component';
import BloodPressure from '#app/icons/blood-pressure.svg?component';
import BloodDrop from '#app/icons/blood-drop.svg?component';
import WeightScale from '#app/icons/weight-scale.svg?component';
import DayList from './day-list.gts';
import {
  asMonthDay,
  asYYYYMMDD,
  toEndOfLocalDay,
  toStartOfLocalDay,
} from '#app/utils/dates.ts';
import { service } from '@ember/service';
import { trackedObject } from '@ember/reactive/collections';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import { collections } from '#app/models/collections.ts';
import type FirebaseService from '#app/services/firebase.ts';
import type Owner from '@ember/owner';
import { task } from 'ember-concurrency';
import { pageTitle } from 'ember-page-title';

const DAY_IN_MS = 24 * 60 * 60 * 1000;

export interface MeasurementLoaderAndFiltererSignature {
  Args: object;
  Blocks: {
    default: [
      filteredKindsByDay: Map<string, (BpKind | GlucoseKind | WeightKind)[]>,
    ];
  };
  Element: HTMLDivElement;
}

export default class MeasurementLoaderAndFilterer extends Component<MeasurementLoaderAndFiltererSignature> {
  @service declare firebase: FirebaseService;
  @tracked includeBps = true;
  @tracked includeGlucoses = true;
  @tracked includeWeights = true;
  // Show one week by default
  @tracked startDate = asYYYYMMDD(new Date(Date.now() - 7 * DAY_IN_MS));
  @tracked endDate = asYYYYMMDD(new Date(Date.now()));

  constructor(
    owner: Owner,
    args: MeasurementLoaderAndFiltererSignature['Args']
  ) {
    super(owner, args);
    void this.loadData.perform();
  }

  get uid() {
    return this.firebase.uid;
  }

  #measurements = trackedObject({
    bps: [] as BpMeasurement[],
    glucoses: [] as GlucoseMeasurement[],
    weights: [] as WeightMeasurement[],
  });

  loadData = task({ restartable: true }, async () => {
    console.groupCollapsed('[loader-and-filterer] loadData...');

    const start = toStartOfLocalDay(this.startDate);
    const end = toEndOfLocalDay(this.endDate);

    const queryPieces = {
      limit: 900, // safeguard to prevent big queries
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

    console.log(
      `Loaded ${glucoses.length} glucoses, ${weights.length} weights, ${bps.length} bps`
    );
    if (
      glucoses.length === 900 ||
      weights.length === 900 ||
      bps.length === 900
    ) {
      console.warn(`Max records returned, check logic`);
    }

    this.#measurements.glucoses = glucoses;
    this.#measurements.bps = bps;
    this.#measurements.weights = weights;
    console.groupEnd();
  });

  updateFilter = (
    key: 'includeBps' | 'includeGlucoses' | 'includeWeights',
    value: boolean
  ) => {
    // Only set the value if it has changed
    if (this[key] !== value) {
      this[key] = value;
    }
  };

  /**
   * Action called for every change in the form (check/uncheck).
   */
  updatedOptions = (evt: Event) => {
    evt.preventDefault();

    const formData = new FormData(evt.currentTarget as HTMLFormElement);
    const data = Object.fromEntries(formData.entries());
    this.updateFilter('includeBps', data.withBps === 'on');
    this.updateFilter('includeGlucoses', data.withGlucoses === 'on');
    this.updateFilter('includeWeights', data.withWeights === 'on');

    if (
      this.startDate !== (data.startDate as string) ||
      this.endDate !== (data.endDate as string)
    ) {
      this.startDate = (data.startDate as string) ?? '';
      this.endDate = (data.endDate as string) ?? '';
      void this.loadData.perform();
    }
  };

  /**
   * This represents all the data, flattened into a single array with a 'kind'
   * discrimanator of 'bp', 'glucose', or 'weight'.  Since it's cached, it should
   * only rebuild this when the measurements data changes.
   */
  @cached
  get allKinds() {
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
    const dayMap: Record<string, (BpKind | GlucoseKind | WeightKind)[]> = {};
    for (const mwk of this.filteredKinds) {
      const date = asYYYYMMDD(mwk.measurement.timestamp);
      if (!dayMap[date]) {
        dayMap[date] = [];
      }
      dayMap[date].push(mwk);
    }

    return dayMap;
  }

  <template>
    {{pageTitle (asMonthDay this.startDate) " - " (asMonthDay this.endDate)}}

    <div ...attributes>

      <div data-docs="FILTERS">
        <form {{on "change" this.updatedOptions}}>
          <div class="flex flex-col md:flex-row gap-2">
            <fieldset
              class="fieldset bg-base-100 border-base-300 rounded-box w-full border p-4"
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

            <fieldset
              class="fieldset bg-base-100 border-base-300 rounded-box w-full border p-4"
            >
              <legend class="fieldset-legend">Date Range</legend>
              <div class="form-control">
                <label class="label" for="start-date">
                  <span class="label-text">Start Date</span>
                </label>
                <input
                  id="start-date"
                  name="startDate"
                  type="date"
                  class="input input-bordered w-full"
                  value={{this.startDate}}
                  required
                />
              </div>
              <div class="form-control">
                <label class="label" for="end-date">
                  <span class="label-text">End Date</span>
                </label>
                <input
                  id="end-date"
                  name="endDate"
                  type="date"
                  class="input input-bordered w-full"
                  value={{this.endDate}}
                  required
                />
              </div>
            </fieldset>
          </div>
        </form>

      </div>
      <div data-docs="LIST">
        <DayList @days={{this.filteredKindsByDay}} />
      </div>
    </div>
    {{yield}}
  </template>
}
