import { collectionsBuilder } from 'zod-firebase';

import { NoticeSchema } from './notice';
import { AppUserSchema } from './app-user';
import { Timestamp } from 'firebase/firestore';

const schema = {
  appUsers: {
    zod: AppUserSchema,
  },
  notices: {
    zod: NoticeSchema,
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
