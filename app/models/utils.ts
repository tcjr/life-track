import {
  type DocumentData,
  type QueryDocumentSnapshot,
  type FirestoreDataConverter,
  type SnapshotOptions,
  Timestamp,
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

      // TODO: Dates probably need to be converted to Timestamp

      return validated as DocumentData;
    },

    fromFirestore(snapshot: QueryDocumentSnapshot, options: SnapshotOptions) {
      const data = snapshot.data(options);
      console.log('Raw data from Firestore:', data);

      // Go through the data (top-level only) and convert any Timestamp values
      // to JavaScript Date values.
      // TODO: Check efficiency of this; maybe look for a way that is more efficient.
      const convertedData = Object.keys(data).reduce<DocumentData>(
        (cvt, key) => {
          if (data[key] instanceof Timestamp) {
            // replace Timestamp with Date
            cvt[key] = data[key].toDate();
          } else {
            // just copy non-Timestamp values
            cvt[key] = data[key];
          }
          return cvt;
        },
        {}
      );

      console.log('converted, before validation:', convertedData);

      // Validate and add useful properties (e.g., id)
      const validated = schema.parse(convertedData);
      const appModelData = Object.defineProperties(validated, {
        id: { value: snapshot.id },
      });
      console.log('Converted & validated data:', appModelData);
      return appModelData as T;
    },
  };
}
