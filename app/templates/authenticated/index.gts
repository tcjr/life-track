import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';

export interface IndexSignature {
  Element: HTMLDivElement;
}

export default class Index extends Component<IndexSignature> {
  <template>
    {{pageTitle "Index"}}
    <div ...attributes>
      <h3 class="text-3xl font-bold text-center mb-5">What do you want to do?</h3>
      <ul class="flex flex-col gap-4">
        <li><a class="btn btn-primary btn-xl w-full" href="/new-measurement">New
            Measurement</a></li>
        <li><a
            class="btn btn-primary btn-xl w-full"
            href="/trends"
          >Meal</a></li>
      </ul>
    </div>
  </template>
}
