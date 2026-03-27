import { collectionsBuilder } from 'zod-firebase-admin';
import { NoticeSchema } from '../models/notice.mjs';
import { ReportSchema } from '../models/report.mjs';
import { BpSchema } from '../models/bp.mjs';
import { GlucoseSchema } from '../models/glucose.mjs';
import { MealSchema } from '../models/meal.mjs';
import { initializeApp, getApps } from 'firebase-admin/app';
import { Timestamp } from 'firebase-admin/firestore';
import * as logger from 'firebase-functions/logger';

const schema = {
  'app-users': {
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
  notices: {
    zod: NoticeSchema,
  },
  reports: {
    zod: ReportSchema,
  },
} as const;

export default async function setupApp() {
  const app = getApps().length === 0 ? initializeApp() : getApps()[0]!;

  const collections = collectionsBuilder(schema, {
    snapshotDataConverter: (snapshot) => {
      const data = snapshot.data();
      // Convert Firestore Timestamps to JavaScript Dates
      return Object.fromEntries(
        Object.entries(data).map(([key, value]) => [
          key,
          value instanceof Timestamp ? value.toDate() : value,
        ]),
      );
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
