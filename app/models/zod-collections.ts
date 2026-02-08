import {
  collectionsBuilder,
  type DocumentInput,
  type DocumentOutput,
} from 'zod-firebase';

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

// export type AppUserOutput = SchemaDocumentOutput<typeof schema.appUsers>;
// export type NoticeOutput = SchemaDocumentOutput<typeof schema.notices>;

// TODO: remove "Output" from these type names
export type AppUserOutput = DocumentOutput<typeof AppUserSchema>;
export type NoticeOutput = DocumentOutput<typeof NoticeSchema>;

export type AppUserInput = DocumentInput<typeof AppUserSchema>;
export type NoticeInput = DocumentInput<typeof NoticeSchema>;

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
