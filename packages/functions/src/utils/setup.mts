import { collectionsBuilder } from 'zod-firebase-admin';
import { NoticeSchema } from '../models/notice.mjs';
import { initializeApp } from 'firebase-admin/app';
import { Timestamp } from 'firebase-admin/firestore';

const schema = {
  notices: {
    zod: NoticeSchema,
  },
} as const;

export default async function setupApp() {
  const app = initializeApp();

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

  return { app, collections };
}
