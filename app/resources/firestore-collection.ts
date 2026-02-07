import { cell, resource, resourceFactory } from 'ember-resources';
import {
  onSnapshot,
  query,
  collection,
  type FirestoreDataConverter,
} from 'firebase/firestore';

type ResourceOptions = {
  verbose?: boolean;
};

const DEFAULT_OPTIONS: ResourceOptions = {
  verbose: false,
};

/**
 * Resource representing a Firestore collection at the given `collectionName`.
 * The collection documents (after conversion) are the resource's value as an array.
 *
 * Usage:
 *  * In component GTS files:
 *
 * ```gts
 *   @use things = FirestoreCollection('things', thingsConverter, { verbose: true });
 *
 *  <template>
 *    <ul>
 *      {{#each this.things as |thing|}}
 *        <li>{{thing.id}}</li>
 *      {{/each}}
 *    </ul>
 *  </template>
 * ```
 *
 * @param collectionName The name of the collection
 * @param converter FirestoreDataConverter to use for converting the documents
 */
export function FirestoreCollection<AppModelType = Record<string, unknown>>(
  collectionName: string,
  converter: FirestoreDataConverter<AppModelType>,
  options: ResourceOptions = DEFAULT_OPTIONS
) {
  if (options.verbose) {
    console.log(
      'NEW FIRESTORE COLLECTION RESOURCE',
      collectionName,
      converter,
      options
    );
  }
  return resource(({ on, owner }) => {
    const log = (...args: unknown[]) => {
      if (options.verbose) {
        console.log(`[🔥Collection ${collectionName}] `, ...args);
      }
    };

    log('looking up firebase service on owner to get Firestore db');
    const db = owner.lookup('service:firebase').db;

    const collectionRef = collection(db, collectionName).withConverter(
      converter
    );

    log('building query');
    const q = query(collectionRef);

    // This is where the actual data is stored.
    const data = cell<AppModelType[]>([]);

    log('setting up onSnapshot listener for collection');
    const unsub = onSnapshot(q, (querySnapshot) => {
      const results: AppModelType[] = [];
      log(
        `received collection query snapshot with ${querySnapshot.size} documents`
      );
      querySnapshot.forEach((docSnap) => {
        const docData = docSnap.data();
        results.push(docData);
      });
      // Replace the whole array for now
      data.current = results;
    });

    on.cleanup(() => {
      log('Cleaning up Firestore collection listener');
      unsub();
    });

    // This is what will be returned when the resource is used. Any state
    // we want to look at in the template should be exposed here.
    return () => data.current;
  });
}

// You have to do this registration so the resource can be used in templates.
resourceFactory(FirestoreCollection);
