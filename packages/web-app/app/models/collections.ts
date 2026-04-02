import { collectionsBuilder } from 'zod-firebase';

import { NoticeSchema } from './notice';
import { AppUserSchema } from './app-user';
import { ReportSchema } from './report';
import { BpMeasurementSchema } from './measurements/bp';
import { GlucoseMeasurementSchema } from './measurements/glucose';
import { convertTimestampsToDates } from '#app/utils/firestore.ts';

const schema = {
  'app-users': {
    zod: AppUserSchema,
    bps: {
      zod: BpMeasurementSchema,
    },
    glucoses: {
      zod: GlucoseMeasurementSchema,
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
    convertTimestampsToDates(data);
    return data;
  },
});
