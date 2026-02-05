import { cell, resource, resourceFactory } from 'ember-resources';
import {
  onSnapshot,
  doc,
  type FirestoreDataConverter,
} from 'firebase/firestore';

type ResourceOptions = {
  verbose?: boolean;
};

const DEFAULT_OPTIONS: ResourceOptions = {
  verbose: false,
};

/**
 * Resource representing a single Firestore document at the given `path`.
 * The document contents (after conversion) are the resource's value.
 *
 * Usage:
 *
 * In template only contexts:
 *
 * ```hbs
 *{{#let (FirestoreDoc 'path/to/doc' DocConverter (hash verbose=true)) as |doc|}}
 *  <pre>{{stringify doc}}</pre>
 *{{/let}}
 * ```
 *
 * In component GTS files:
 *
 * ```gts
 *   @use thing = FirestoreDoc('path/to/doc', DocConverter, { verbose: true });
 *
 *  <template>
 *    {{#if this.thing}}
 *      <pre>{{stringify this.thing}}</pre>
 *   {{/if}}
 *  </template>
 * ```
 *
 * The document is converted to using the given converter so it's correctly
 * typed.
 *
 * Users of this resource should check for `undefined` since that is what the
 * current value will be until the document is initially loaded.
 *
 * If the document at this path is deleted after this firesource is created, the
 * resource's value will not be updated and will remain what the last value was.
 *
 * @param path Path to the document
 * @param converter FirestoreDataConverter to use for converting the document
 */
export function FirestoreDoc<AppModelType = Record<string, unknown>>(
  path: string | (() => string), // reactive arg
  converter: FirestoreDataConverter<AppModelType>,
  options: ResourceOptions = DEFAULT_OPTIONS
) {
  console.log('NEW FIRESTORE DOC RESOURCE FOR PATH:', path, converter, options);
  return resource(({ on, owner }) => {
    const documentPath = typeof path === 'function' ? path() : path;

    const log = (...args: unknown[]) => {
      if (options.verbose) {
        console.log(`[🔥${documentPath}] `, ...args);
      }
    };
    log('in resource() ...');

    // This is where the actual data is stored.
    const data = cell<AppModelType>();

    log('looking up firebase service on owner to get Firestore db');
    const db = owner.lookup('service:firebase').db;

    // Build a document ref using the path. Also, attach the converter so the
    // model <--> Firestore conversion happens automatically on load and save.
    const docRef = doc(db, documentPath).withConverter(converter);

    log(`Subscribing to Firestore document at path: ${documentPath}`);
    // The listener for Firestore updates. We update the cell `data` when a
    // change is detected.
    const unsub = onSnapshot(docRef, (docSnap) => {
      // WHEN WE START USING CONVERTERS:
      // At this point, the snapshot here, `docSnap` has already been converted
      // to a model using the converter.
      const docData = docSnap.data();

      // I'm not sure if this is the best way to do this or not.  Specifically, I think it might
      // make more sense to clear the current value when the document is deleted.
      if (docData) {
        data.current = docData;
      } else {
        //log('no data for path; leaving resource value unchanged');
        log('no data for path; leaving resource value unchanged');
      }
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
resourceFactory(FirestoreDoc);
