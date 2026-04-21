import Component from '@glimmer/component';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import { cached, tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import Heart from '#app/icons/heart.svg?component';
import BloodPressure from '#app/icons/blood-pressure.svg?component';
import BloodDrop from '#app/icons/blood-drop.svg?component';
import WeightScale from '#app/icons/weight-scale.svg?component';
import Glucose from '#app/components/measurement/glucose.gts';
import Bp from '#app/components/measurement/bp.gts';
import Weight from '#app/components/measurement/weight.gts';
import { eq } from 'ember-truth-helpers';
import { asYYYYMMDD } from '#app/utils/dates.ts';
import DateParts from '../date-parts.gts';

interface MeasurementRangeListSignature {
  Args: {
    measurements: {
      bps: BpMeasurement[];
      glucoses: GlucoseMeasurement[];
      weights: WeightMeasurement[];
    };
  };
}

interface BpKind {
  kind: 'bp';
  measurement: BpMeasurement;
}

interface GlucoseKind {
  kind: 'glucose';
  measurement: GlucoseMeasurement;
}

interface WeightKind {
  kind: 'weight';
  measurement: WeightMeasurement;
}

export default class MeasurementRangeList extends Component<MeasurementRangeListSignature> {
  @tracked includeBps = true;
  @tracked includeGlucoses = true;
  @tracked includeWeights = true;

  updatedOptions = (evt: Event) => {
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
    const ms = this.args.measurements;
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
  get filteredKindsByDay() {
    const dayMap = new Map<string, (BpKind | GlucoseKind | WeightKind)[]>();
    for (const mwk of this.filteredKinds) {
      const date = asYYYYMMDD(mwk.measurement.timestamp);
      if (!dayMap.has(date)) {
        dayMap.set(date, []);
      }
      dayMap.get(date)?.push(mwk);
    }

    return dayMap;
    // Sort the keys
    // We don't need to sort the keys because the records are sorted already.
    // TODO: Verify this.
    // const sorted = [...dayMap.keys()]
    //   .sort((a, b) => a.localeCompare(b))
    //   .reduce(
    //     (r, key) => r.set(key, dayMap.get(key)!),
    //     new Map<string, (BpKind | GlucoseKind | WeightKind)[]>()
    //   );

    // return sorted;
  }

  <template>
    <div>
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

    <hr />
    <div class="flex flex-col bg-base-100">
      {{#each-in this.filteredKindsByDay as |day mwks|}}
        <div
          class="flex flex-row justify-between border border-base-300 rounded px-3 py-2 mt-2 bg-primary text-primary-content"
        >
          <DateParts @date={{day}} as |d|>
            <div>
              {{d.weekday}}
            </div>
            <div>
              {{d.month}}
              {{d.day}}
            </div>
          </DateParts>
        </div>

        <div class="flex flex-col gap-2">
          {{#each mwks as |measurementWithKind|}}
            {{#if (eq measurementWithKind.kind "glucose")}}
              {{! @glint-expect-error: narrowing should work here}}
              <Glucose @measurement={{measurementWithKind.measurement}} />
            {{/if}}
            {{#if (eq measurementWithKind.kind "bp")}}
              {{! @glint-expect-error: narrowing should work here}}
              <Bp @measurement={{measurementWithKind.measurement}} />
            {{/if}}
            {{#if (eq measurementWithKind.kind "weight")}}
              {{! @glint-expect-error: narrowing should work here}}
              <Weight @measurement={{measurementWithKind.measurement}} />
            {{/if}}
          {{/each}}
        </div>

      {{/each-in}}
    </div>
  </template>
}
