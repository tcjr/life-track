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

  get allKindsByDay() {
    const dayMap = new Map<string, (BpKind | GlucoseKind | WeightKind)[]>();
    for (const mwk of this.allKinds) {
      const date = asYYYYMMDD(mwk.measurement.timestamp);
      if (!dayMap.has(date)) {
        dayMap.set(date, []);
      }
      dayMap.get(date)?.push(mwk);
    }
    // Sort the keys
    // TODO: check to see if they are already sorted because the records are sorted
    const sorted = [...dayMap.keys()]
      .sort((a, b) => a.localeCompare(b))
      .reduce(
        (r, key) => r.set(key, dayMap.get(key)!),
        new Map<string, (BpKind | GlucoseKind | WeightKind)[]>()
      );

    return sorted;
  }

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
    <div>
      {{#each-in this.allKindsByDay as |day mwks|}}
        <div>
          DAY:
          {{day}}
          (count:
          {{mwks.length}})
        </div>

        <div>
          {{#each mwks as |measurementWithKind|}}
            {{#if this.includeGlucoses}}
              {{#if (eq measurementWithKind.kind "glucose")}}
                {{! @glint-expect-error: narrowing should work here}}
                <Glucose @measurement={{measurementWithKind.measurement}} />
              {{/if}}
            {{/if}}
            {{#if this.includeBps}}
              {{#if (eq measurementWithKind.kind "bp")}}
                {{! @glint-expect-error: narrowing should work here}}
                <Bp @measurement={{measurementWithKind.measurement}} />
              {{/if}}
            {{/if}}
            {{#if this.includeWeights}}
              {{#if (eq measurementWithKind.kind "weight")}}
                {{! @glint-expect-error: narrowing should work here}}
                <Weight @measurement={{measurementWithKind.measurement}} />
              {{/if}}
            {{/if}}
          {{/each}}
        </div>

      {{/each-in}}
    </div>
  </template>
}
