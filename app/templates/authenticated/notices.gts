import Component from '@glimmer/component';
import { use } from 'ember-resources';
import { noticeConverter } from 'life-track/models/notice';
import { FirestoreCollection } from 'life-track/resources/firestore-collection';
import { pageTitle } from 'ember-page-title';

const asLocal = (date: Date) => {
  return date.toLocaleDateString();
};

export interface NoticesSignature {
  Element: HTMLDivElement;
}

export default class Notices extends Component<NoticesSignature> {
  @use allNotices = FirestoreCollection('notices', noticeConverter, {
    verbose: true,
  });

  // Since we don't have a proper collection query support yet, we're going to do
  // client-side filtering of the notices. We only want to show notices where
  // the current date is between the startAt and endAt dates.

  get currentNotices() {
    if (!this.allNotices) {
      return [];
    }
    // TODO: filter these
    return this.allNotices;
  }

  <template>
    {{pageTitle "Notices"}}
    <div ...attributes>
      {{#each this.currentNotices as |notice|}}

        <div role="alert" class="alert alert-vertical sm:alert-horizontal">
          <div>
            <h3 class="font-bold">{{notice.text}}</h3>
            <div class="text-xs">Valid from
              {{asLocal notice.startAt}}
              through
              {{asLocal notice.endAt}}</div>
          </div>
        </div>

      {{/each}}
    </div>
  </template>
}
