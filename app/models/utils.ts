import type {
  DocumentData,
  QueryDocumentSnapshot,
  FirestoreDataConverter,
  SnapshotOptions,
} from 'firebase/firestore';
import { z } from 'zod';

// NOTE: The downside of using converters built this way is that they're not
// classes, so we can't add methods/getters/etc to them. I think that'll be ok.

export function zodFirestoreConverter<
  S extends z.ZodType,
  T = z.infer<S> & { id: string },
>(schema: S): FirestoreDataConverter<T> {
  return {
    toFirestore(document: T): DocumentData {
      // Validate before writing
      const validated = schema.parse(document);
      return validated as DocumentData;
    },

    fromFirestore(snapshot: QueryDocumentSnapshot, options: SnapshotOptions) {
      const data = snapshot.data(options);
      console.log('Raw data from Firestore:', data);
      // Validate and add useful properties (e.g., id)
      const validated = schema.parse(data);
      const appModelData = Object.defineProperties(validated, {
        id: { value: snapshot.id },
        //_ref: { value: () => snapshot.ref },
      });
      console.log('Converted data:', appModelData);
      return appModelData as T;
    },
  };
}
