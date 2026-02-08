import { cell, resource, resourceFactory } from 'ember-resources';
import {
  DocumentSnapshot,
  onSnapshot,
  QuerySnapshot,
} from 'firebase/firestore';
import { collections } from 'life-track/models/zod-collections';
import { type DocumentOutput, type QuerySpecification } from 'zod-firebase';

// Use a mapped type to extract the document output type for each collection
type CollectionDocumentOutput<K extends keyof typeof collections> =
  DocumentOutput<(typeof collections)[K]['zod']>;

// Preserve schema-aware typing by using the parameter type of the
// collection's `prepare` method. This ties this type to the specific
// collection `K` so callers get proper autocompletion and checks.
type CollectQuerySpec<K extends keyof typeof collections> = Parameters<
  (typeof collections)[K]['prepare']
>[0] & {
  verbose?: boolean;
};

// SchemaType is something like <typeof NoticeSchema>
export function FirestoreQuery<K extends keyof typeof collections>(
  collectionName: K,
  querySpec: CollectQuerySpec<K>
) {
  type DocOut = CollectionDocumentOutput<K>;

  const collectionToQuery = collections[collectionName];
  // NOTE: I'm not sure why I need to cast here
  const queryName = (querySpec as QuerySpecification).name;
  const isVerbose = Boolean(querySpec.verbose);

  if (isVerbose) {
    console.log(
      `SETTING UP FIRESTORE QUERY`,
      collectionName,
      queryName,
      querySpec
    );
  }

  return resource(({ on }) => {
    const log = (...args: unknown[]) => {
      if (isVerbose) {
        console.log(`[Query ${queryName}] `, ...args);
      }
    };
    // This is where the actual data is stored.
    const data = cell<DocOut[]>([]);

    log('building query');
    // Call prepare with the typed `querySpec`. We still cast the prepared
    // query to `any` for `onSnapshot` because the firebase overloads are
    // difficult to satisfy across the library's converters.
    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument, @typescript-eslint/no-explicit-any
    const prepared = collectionToQuery.prepare(querySpec as any);

    log('setting up onSnapshot listener for query');
    const unsub = onSnapshot(
      // eslint-disable-next-line @typescript-eslint/no-unsafe-argument, @typescript-eslint/no-explicit-any
      prepared as any,
      (querySnapshot: QuerySnapshot) => {
        const results: DocOut[] = [];
        log(`received query snapshot with ${querySnapshot.size} documents`);
        querySnapshot.forEach((docSnap: DocumentSnapshot) => {
          const docData = docSnap.data();
          results.push(docData as DocOut);
        });
        // Replace the whole array for now
        data.current = results;
      }
    );

    on.cleanup(() => {
      log('Cleaning up Firestore query listener');
      unsub();
    });

    // This is what will be returned when the resource is used. Any state
    // we want to look at in the template should be exposed here.
    return () => data.current;
  });
}

// You have to do this registration so the resource can be used in templates.
resourceFactory(FirestoreQuery);
