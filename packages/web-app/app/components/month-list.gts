import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import {
  type Calendar,
  createCalendar,
  destroyCalendar,
  List,
} from '@event-calendar/core';
import HeartUrl from '#app/icons/heart.svg';
import BloodPressureUrl from '#app/icons/blood-pressure.svg';
import BloodDropUrl from '#app/icons/blood-drop.svg';
import WeightUrl from '#app/icons/weight-scale.svg';
import Heart from '#app/icons/heart.svg?component';
import BloodPressure from '#app/icons/blood-pressure.svg?component';
import BloodDrop from '#app/icons/blood-drop.svg?component';
import WeightIcon from '#app/icons/weight-scale.svg?component';
import { cached, tracked } from '@glimmer/tracking';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import type { WeightMeasurement } from '#app/models/measurements/weight.ts';
import { BP_COLORS, getBpQuality } from '#app/utils/bp.ts';
import { WEIGHT_COLORS, getWeightQuality } from '#app/utils/weight.ts';
import {
  getGlucoseContextName,
  getGlucoseQuality,
  GLUCOSE_COLORS,
} from '#app/utils/glucose.ts';
import { on } from '@ember/modifier';
import { registerDestructor } from '@ember/destroyable';

interface MonthListSignature {
  Element: HTMLDivElement;
  Args: {
    measurements: {
      bps: BpMeasurement[];
      glucoses: GlucoseMeasurement[];
      weights: WeightMeasurement[];
    };
  };
}

// Example event
// {
//   id: 'evt3',
//   start: '2026-03-14 08:35',
//   end: '2026-03-14 08:36',
//   title: {
//     html: `<img src="${BloodDropUrl}" class="inline-block align-text-bottom h-5"> Glucose 170`,
//   },
//   backgroundColor: 'var(--color-warning)',
//   textColor: 'var(--color-warning-content)',
// },

const getEventForBp = (bp: BpMeasurement) => {
  const quality = getBpQuality(bp);
  const colors = BP_COLORS[quality];
  return {
    id: bp._id,
    start: bp.timestamp,
    end: bp.timestamp,
    title: {
      html: `<img src="${BloodPressureUrl}" class="inline-block align-text-bottom h-5"> BP ${bp.systolic}/${bp.diastolic},
             <img src="${HeartUrl}" class="inline-block align-text-bottom h-5"> HR ${bp.heartRate}`,
    },
    backgroundColor: colors.bg,
    textColor: colors.fg,
  };
};

const getEventForGlucose = (glucose: GlucoseMeasurement) => {
  const quality = getGlucoseQuality(glucose);
  const colors = GLUCOSE_COLORS[quality];
  return {
    id: glucose._id,
    start: glucose.timestamp,
    end: glucose.timestamp,
    title: {
      html: `<img src="${BloodDropUrl}" class="inline-block align-text-bottom h-5"> Glucose ${glucose.value} (${getGlucoseContextName(glucose.context)})`,
    },
    backgroundColor: colors.bg,
    textColor: colors.fg,
  };
};

const getEventForWeight = (weight: WeightMeasurement) => {
  const quality = getWeightQuality(weight);
  const colors = WEIGHT_COLORS[quality];
  return {
    id: weight._id,
    start: weight.timestamp,
    end: weight.timestamp,
    title: {
      html: `<img src="${WeightUrl}" class="inline-block align-text-bottom h-5"> Weight ${weight.value} lbs`,
    },
    backgroundColor: colors.bg,
    textColor: colors.fg,
  };
};

export default class MonthList extends Component<MonthListSignature> {
  @tracked includeBps = true;
  @tracked includeGlucoses = true;
  @tracked includeWeights = true;

  @cached
  get calendarEvents() {
    const events = [];
    if (this.includeBps) {
      events.push(...this.bpsEvents);
    }
    if (this.includeGlucoses) {
      events.push(...this.glucosesEvents);
    }
    if (this.includeWeights) {
      events.push(...this.weightsEvents);
    }

    return events;
  }

  @cached
  get bpsEvents() {
    return this.args.measurements.bps.map(getEventForBp);
  }

  @cached
  get glucosesEvents() {
    return this.args.measurements.glucoses.map(getEventForGlucose);
  }

  @cached
  get weightsEvents() {
    return this.args.measurements.weights.map(getEventForWeight);
  }

  #calendar: Calendar | undefined;

  attachCalendar = modifier((elem: HTMLDivElement) => {
    if (!this.#calendar) {
      this.#calendar = createCalendar(elem, [List], {
        view: 'listMonth', //'dayGridMonth',
        events: this.calendarEvents,
        editable: false,
      });

      registerDestructor(this, () => {
        if (this.#calendar) {
          void destroyCalendar(this.#calendar);
        }
      });
    } else {
      this.#calendar.setOption('events', this.calendarEvents);
    }
  });

  updatedOptions = (evt: Event) => {
    evt.preventDefault();

    const formData = new FormData(evt.currentTarget as HTMLFormElement);
    const data = Object.fromEntries(formData.entries());
    this.includeBps = data.withBps === 'on';
    this.includeGlucoses = data.withGlucoses === 'on';
    this.includeWeights = data.withWeights === 'on';
  };

  <template>
    <div ...attributes>
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
                <WeightIcon class="inline-block h-5" />
                Weight
              </span>
            </label>
          </fieldset>
        </form>

      </div>
      <div {{this.attachCalendar}}>
      </div>
    </div>
  </template>
}
