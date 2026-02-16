import Component from '@glimmer/component';
import { getPromiseState } from 'reactiveweb/get-promise-state';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';
import { collections } from '#models/collections';
import type { DocumentReference } from 'firebase/firestore';

type Rest<T extends any[]> = T extends [any, ...infer U] ? U : never;
const partial = <T extends any[], R>(
  fn: (...args: T) => R,
  ...partials: [T[0]] // Specifically type the first argument
) => {
  // Return a new function that closes over the partial arguments
  return (...args: Rest<T>) => {
    return fn(...([...partials, ...args] as T));
  };
};

// Use a mapped type to extract the document output type for each collection
type CollectionDocumentOutput<K extends keyof typeof collections> =
  DocumentOutput<(typeof collections)[K]['zod']>;

type CollectionDocumentInput<K extends keyof typeof collections> =
  DocumentInput<(typeof collections)[K]['zod']>;

interface DocSignature<K extends keyof typeof collections> {
  Args: {
    collection: K;
    id: string;
  };
  Blocks: {
    loading: [];
    error: [];
    loaded: [
      document: CollectionDocumentOutput<K>,
      colExtras: {
        /** This is the collection update() function with the first argument
         * curried to the document id. */
        update: (data: CollectionDocumentInput<K>) => Promise<void>;
        ref: () => DocumentReference;
      },
    ];
  };
}

export default class Doc<K extends keyof typeof collections> extends Component<
  DocSignature<K>
> {
  get _collection() {
    return collections[this.args.collection];
  }

  state = getPromiseState(() => {
    console.log(
      `in ${this.args.collection} collection, getting doc with id ${this.args.id}`
    );
    return this._collection.findById(this.args.id);
  });

  get typedResolved(): CollectionDocumentOutput<K> {
    return this.state.resolved as CollectionDocumentOutput<K>;
  }

  get typedDocumentExtras() {
    return {
      // For the document ref, we partially apply the id as the first
      // argument and return the new function.
      ref: partial(this._collection.read.doc, this.args.id),

      // For the document update, we partially apply the id as the first
      // argument and return the new function.
      update: partial(this._collection.update, this.args.id),
    };
  }

  <template>
    {{#if this.state.isLoading}}
      {{#if (has-block "loading")}}
        {{yield to="loading"}}
      {{else}}
        Loading...
      {{/if}}
    {{else if this.state.error}}
      {{#if (has-block "error")}}
        {{yield to="error"}}
      {{else}}
        Error
      {{/if}}
    {{else if this.state.resolved}}
      {{#if (has-block "loaded")}}
        {{yield this.typedResolved this.typedDocumentExtras to="loaded"}}
      {{else}}
        Success
      {{/if}}
    {{/if}}
  </template>
}
