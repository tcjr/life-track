import { cell, resource, resourceFactory } from 'ember-resources';
import {
  onSnapshot,
  query,
  where,
  orderBy,
  collection,
  type FirestoreDataConverter,
} from 'firebase/firestore';

type ResourceOptions = {
  verbose?: boolean;
};

const DEFAULT_OPTIONS: ResourceOptions = {
  verbose: false,
};

export function FirestoreBasicQuery<AppModelType = Record<string, unknown>>(
  collectionName: string,
  // queryConstraint: QueryConstraint,
  converter: FirestoreDataConverter<AppModelType>,
  options: ResourceOptions = DEFAULT_OPTIONS
) {
  console.log(
    'NEW FIRESTORE BASIC QUERY RESOURCE FOR COLLECTION:',
    collectionName,
    converter,
    options
  );

  return resource(({ on, owner }) => {
    const log = (...args: unknown[]) => {
      if (options.verbose) {
        console.log(`[🔥Query ${collectionName}] `, ...args);
      }
    };

    log('looking up firebase service on owner to get Firestore db');
    const db = owner.lookup('service:firebase').db;

    const collectionRef = collection(db, collectionName).withConverter(
      converter
    );

    log('building query');
    const q = query(
      collectionRef
      // Use some nonsense until we have real constraints
      // where('text', '!=', null)
    );

    // This is where the actual data is stored.
    const data = cell<AppModelType[]>([]);

    log('setting up onSnapshot listener for query');
    const unsub = onSnapshot(q, (querySnapshot) => {
      const results: AppModelType[] = [];
      log(`received query snapshot with ${querySnapshot.size} documents`);
      querySnapshot.forEach((docSnap) => {
        const docData = docSnap.data();
        results.push(docData);
      });
      // Replace the whole array for now
      data.current = results;
    });

    on.cleanup(() => {
      log('Cleaning up Firestore basic query listener');
      unsub();
    });

    // This is what will be returned when the resource is used. Any state
    // we want to look at in the template should be exposed here.
    return () => data.current;
  });
}

// You have to do this registration so the resource can be used in templates.
resourceFactory(FirestoreBasicQuery);
