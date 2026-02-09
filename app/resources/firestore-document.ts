import { cell, resource, resourceFactory } from 'ember-resources';
import { DocumentSnapshot, onSnapshot } from 'firebase/firestore';
import { collections } from '#models/collections';
import { type DocumentOutput } from 'zod-firebase';

// Use a mapped type to extract the document output type for each collection
type CollectionDocumentOutput<K extends keyof typeof collections> =
  DocumentOutput<(typeof collections)[K]['zod']>;

type Options = {
  verbose?: boolean;
};

/**
 * Resource representing a single Firestore document in the given collection
 * with the given id.
 *
 * Usage:
 *
 * In template only contexts:
 *
 * ```gts
 *{{#let (FirestoreDocument 'things' 't123 (hash verbose=true)) as |doc|}}
 *  <pre>{{stringify doc}}</pre>
 *{{/let}}
 * ```
 *
 * In component javascript files:
 *
 * ```gts
 *   @use thing = FirestoreDocument('things', 't123', { verbose: true });
 *
 *  <template>
 *    {{#if this.thing}}
 *      <pre>{{stringify this.thing}}</pre>
 *   {{/if}}
 *  </template>
 * ```
 *
 * @param collectionName collection name
 * @param id id or function that returns an id
 */
export function FirestoreDocument<K extends keyof typeof collections>(
  collectionName: K,
  id: string | (() => string),
  options: Options = {}
) {
  type DocOut = CollectionDocumentOutput<K>;

  const collectionToQuery = collections[collectionName];
  const isVerbose = Boolean(options.verbose);

  if (isVerbose) {
    console.log(
      `SETTING UP FIRESTORE DOCUMENT`,
      collectionName,
      id,
      options,
      collectionToQuery
    );
  }

  return resource(({ on }) => {
    const documentId = typeof id === 'function' ? id() : id;
    if (!documentId) {
      return null;
    }
    const log = (...args: unknown[]) => {
      if (isVerbose) {
        console.log(`[🔥Doc ${documentId} (${collectionName})] `, ...args);
      }
    };
    // This is where the actual data is stored.
    const data = cell<DocOut>();

    // This doc ref will have the zod converters already attached
    const docRef = collectionToQuery.read.doc(documentId);
    log('docref is ', docRef);

    log('setting up onSnapshot listener for document');
    const unsub = onSnapshot(docRef, (docSnap: DocumentSnapshot) => {
      log(`received updated document snapshot`);
      const docData = docSnap.data();

      data.current = docData as DocOut;
    });

    on.cleanup(() => {
      log('Cleaning up Firestore document listener');
      unsub();
    });

    // This is what will be returned when the resource is used. Any state
    // we want to look at in the template should be exposed here.
    return () => data.current;
  });
}

// You have to do this registration so the resource can be used in templates.
resourceFactory(FirestoreDocument);
