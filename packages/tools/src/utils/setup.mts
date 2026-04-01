import dotenv from 'dotenv';
import { join } from 'node:path';
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { collectionsBuilder } from 'zod-firebase-admin';
import { AppUserSchema } from '../models/app-user.mts';
import { NoticeSchema } from '../models/notice.mts';
import { GlucoseSchema } from '../models/glucose.mts';
import { BpSchema } from '../models/bp.mts';
import { ReportSchema } from '../models/report.mts';
import { Timestamp } from 'firebase-admin/firestore';
import gradient from 'gradient-string';
const fiery = gradient(['yellow', 'red']);
const cool = gradient(['white', 'purple']);

// Always load .env from monorepo root
dotenv.config({
  path: join(import.meta.dirname, '..', '..', '..', '..', '.env'),
});

export const schema = {
  'app-users': {
    zod: AppUserSchema,
    glucoses: { zod: GlucoseSchema },
    bps: { zod: BpSchema },
  },
  notices: {
    zod: NoticeSchema,
  },
  reports: {
    zod: ReportSchema,
  },
} as const;

export default async function setupApp() {
  const app = initializeApp({
    // applicationDefault() causes it to look at the path in the environment var
    // GOOGLE_APPLICATION_CREDENTIALS
    // It also looks for FIRESTORE_EMULATOR_HOST and respects that.
    credential: applicationDefault(),
  });

  const isProduction = Boolean(!process.env.FIRESTORE_EMULATOR_HOST);

  if (isProduction) {
    console.log('🔥');
    console.log(fiery('🔥 PRODUCTION Firebase Admin initialized.'));
    console.log('🔥');
  } else {
    console.log('⛄');
    console.log(cool('⛄ EMULATOR Firebase Admin initialized.'));
    console.log('⛄');
  }

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
  });

  return { app, collections, isProduction };
}
