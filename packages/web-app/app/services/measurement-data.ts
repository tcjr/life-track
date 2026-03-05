import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import { asYYYYMMDD } from '#app/utils/dates.ts';
import { trackedObject } from '@ember/reactive/collections';
import Service from '@ember/service';

type MeasurementValue =
  | { type: 'bp'; measurement: BpMeasurement }
  | { type: 'glucose'; measurement: GlucoseMeasurement };

type DayMap = Map<string, MeasurementValue[]>;

// This is a reaction to me not being able to get context provider/consumer to work.
export default class MeasurementDataService extends Service {
  allMeasurements = trackedObject({
    bps: [] as BpMeasurement[],
    glucoses: [] as GlucoseMeasurement[],
  });

  // Return a Map with keys in the form "YYYY-MM-DD" with the measurements
  // for that day.  The value for each key is an object
  // with a `type` and a `measurement` key, like this:
  // {
  //   type: 'bp',
  //   measurement: { ... }
  // }
  // or
  // {
  //   type: 'glucose',
  //   measurement: { ... }
  // }
  //
  get allByDay() {
    const all = [...this.allMeasurements.bps, ...this.allMeasurements.glucoses];

    const dayMap: DayMap = new Map();

    for (const measurement of all) {
      const date = asYYYYMMDD(measurement.timestamp);

      if (!date) {
        continue;
      }
      if (!dayMap.has(date)) {
        dayMap.set(date, []);
      }

      let obj: MeasurementValue;
      // NOTE: This is hacky because I don't have the type name anywhere right now.
      //       Maybe I can have the zod collections put it in there like the id.
      if ('systolic' in measurement) {
        obj = { type: 'bp', measurement };
      } else if ('value' in measurement) {
        obj = { type: 'glucose', measurement };
      } else {
        // throw out the unknown measurements for now
        continue;
      }

      dayMap.get(date)?.push(obj);
    }

    const sorted: DayMap = [...dayMap.keys()]
      .sort((a, b) => a.localeCompare(b))
      .reduce((r, key) => r.set(key, dayMap.get(key)), new Map());

    return sorted;
  }
}

declare module '@ember/service' {
  interface Registry {
    measurementData: MeasurementDataService;
  }
}
