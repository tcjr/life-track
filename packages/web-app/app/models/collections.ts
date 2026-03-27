import { collectionsBuilder } from 'zod-firebase';

import { NoticeSchema } from './notice';
import { AppUserSchema } from './app-user';
import { ReportSchema } from './report';
import { Timestamp } from 'firebase/firestore';
import { BpMeasurementSchema } from './measurements/bp';
import { GlucoseMeasurementSchema } from './measurements/glucose';
import { MealSchema } from './measurements/meal';

const schema = {
  'app-users': {
    zod: AppUserSchema,
    bps: {
      zod: BpMeasurementSchema,
    },
    glucoses: {
      zod: GlucoseMeasurementSchema,
    },
    meals: {
      zod: MealSchema,
    },
  },
  notices: {
    zod: NoticeSchema,
  },
  reports: {
    zod: ReportSchema,
  },
} as const;

// build type-safe collections
export const collections = collectionsBuilder(schema, {
  snapshotDataConverter: (snapshot) => {
    const data = snapshot.data();
    // Convert Firestore Timestamps to JavaScript Dates
    return Object.fromEntries(
      Object.entries(data).map(([key, value]) => [
        key,
        value instanceof Timestamp ? value.toDate() : value,
      ])
    );
  },
});
