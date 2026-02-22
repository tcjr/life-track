import 'dotenv/config';
import { initializeApp, applicationDefault, cert } from 'firebase-admin/app';
//import serviceAccount from '../../../service-account/credentials.json' with { type: 'json' };
import { collectionsBuilder } from 'zod-firebase-admin';
import { AppUserSchema } from '../models/app-user.mts';

const schema = {
  'app-users': {
    zod: AppUserSchema,
  },
} as const;

export default async function setupApp() {
  const app = initializeApp({
    // applicationDefault() causes it to look at the path in the environment var
    // GOOGLE_APPLICATION_CREDENTIALS
    credential: applicationDefault(),
  });
  console.log('Firebase Admin initialized.');

  const collections = collectionsBuilder(schema);

  return { app, collections };
}
