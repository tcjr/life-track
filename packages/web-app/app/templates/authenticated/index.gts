import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import Clinical from '#app/icons/clinical-fe.svg?component';

export interface IndexSignature {
  Element: HTMLDivElement;
}

export default class Index extends Component<IndexSignature> {
  <template>
    {{pageTitle "Home"}}
    <div ...attributes>
      <h3 class="text-3xl font-bold text-center mb-5">What do you want to do?</h3>
      <ul class="flex flex-col gap-4">
        <li>
          <a class="btn btn-secondary btn-xl w-full" href="/new-measurement">
            <Clinical class="h-8" />
            Track something
          </a>
        </li>
      </ul>
    </div>
  </template>
}
