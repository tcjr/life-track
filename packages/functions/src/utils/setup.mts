import { collectionsBuilder } from 'zod-firebase-admin';
import { NoticeSchema } from '../models/notice.mjs';
import { AppUserSchema } from '../models/app-user.mjs';
import { ReportSchema } from '../models/report.mjs';
import { BpSchema } from '../models/bp.mjs';
import { GlucoseSchema } from '../models/glucose.mjs';
import { MealSchema } from '../models/meal.mjs';
import { initializeApp } from 'firebase-admin/app';
import * as logger from 'firebase-functions/logger';
import { convertTimestampsToDates } from './timestamp-converter.mjs';

const schema = {
  'app-users': {
    zod: AppUserSchema,
    bps: {
      zod: BpSchema,
    },
    glucoses: {
      zod: GlucoseSchema,
    },
    meals: {
      zod: MealSchema,
    },
  },
  'notices': {
    zod: NoticeSchema,
  },
  'reports': {
    zod: ReportSchema,
  },
} as const;

export default async function setupApp() {
  const app = initializeApp();

  const collections = collectionsBuilder(schema, {
    snapshotDataConverter: (snapshot) => {
      const data = snapshot.data();
      // Convert Firestore Timestamps to JavaScript Dates
      convertTimestampsToDates(data);
      return data;
    },

    // When we have a validation error
    zodErrorHandler: (error, snapshot) => {
      logger.error(
        `Validation (zod) failed for document "${snapshot.id}":`,
        error,
      );
      return new Error(`Invalid document: ${snapshot.id}`);
    },
  });

  return { app, collections };
}
