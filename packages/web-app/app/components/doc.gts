import Component from '@glimmer/component';
import {
  getPromiseState,
  type Error as PromiseStateError,
} from 'reactiveweb/get-promise-state';
import { type DocumentInput, type DocumentOutput } from 'zod-firebase';
import { collections } from '#models/collections';
import type { DocumentReference } from 'firebase/firestore';

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
    error: [error: PromiseStateError];
    loaded: [
      document: CollectionDocumentOutput<K>,
      colExtras: {
        /** This is the collection update() function with the first argument
         * curried to the document id. */
        update: (data: Partial<CollectionDocumentInput<K>>) => Promise<void>;
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
    if (!this.args.id) {
      throw new Error('No id provided');
    }
    return this._collection.findById(this.args.id);
  });

  get typedResolved(): CollectionDocumentOutput<K> {
    return this.state.resolved as CollectionDocumentOutput<K>;
  }

  get typedDocumentExtras() {
    return {
      // For the document ref, we partially apply the id as the first
      // argument and return the new function.
      ref: () => this._collection.read.doc(this.args.id),

      // For the document update, we partially apply the id as the first
      // argument and return the new function.
      update: (data: Partial<CollectionDocumentInput<K>>) =>
        // Casting to 'any' to avoid lint errors while handling correlated
        // union types.
        // eslint-disable-next-line @typescript-eslint/no-explicit-any, @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
        (this._collection as any).update(this.args.id, data),
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
        {{yield this.state.error to="error"}}
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
