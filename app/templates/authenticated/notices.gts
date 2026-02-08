import Component from '@glimmer/component';
import { use } from 'ember-resources';
import { noticeConverter } from 'life-track/models/notice';
import { FirestoreCollection } from 'life-track/resources/firestore-collection';
import { pageTitle } from 'ember-page-title';

export interface NoticesSignature {
  Element: HTMLDivElement;
}

export default class Notices extends Component<NoticesSignature> {
  @use allNotices = FirestoreCollection('notices', noticeConverter, {
    verbose: true,
  });

  <template>
    {{pageTitle "Notices"}}
    <div ...attributes>
      {{#if this.allNotices}}
        {{#each this.allNotices as |notice|}}
          <div role="alert" class="alert">
            <span>{{notice.text}}</span>
          </div>
        {{/each}}
      {{/if}}
    </div>
  </template>
}
