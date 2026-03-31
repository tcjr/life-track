import { Timestamp, type DocumentData } from 'firebase/firestore';

/**
 * Utility function that will convert all Timestamp values to Date values. It
 * converts in-place.  If any value is an object or an array, the same process
 * is recursively executed on its content.
 */
export const convertTimestampsToDates = (data: DocumentData) => {
  Object.entries(data).forEach(([key, value]) => {
    if (typeof value !== 'object' || value === null) {
      return;
    }

    if (value instanceof Timestamp) {
      data[key] = value.toDate();
      return;
    }

    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
    data[key] = convertTimestampsToDates(value);
  });

  return data;
};
