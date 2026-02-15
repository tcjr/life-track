import Component from '@glimmer/component';
import { getPromiseState } from 'reactiveweb/get-promise-state';
import { type Collection, type DocumentOutput } from 'zod-firebase';
import { collections } from '#models/collections';

// Use a mapped type to extract the document output type for each collection
type CollectionDocumentOutput<K extends keyof typeof collections> =
  DocumentOutput<(typeof collections)[K]['zod']>;

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
      //  col: Collection
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
        {{yield this.typedResolved this._collection to="loaded"}}
      {{else}}
        Success
      {{/if}}
    {{/if}}
  </template>
}
