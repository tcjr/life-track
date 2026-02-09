import Component from '@glimmer/component';
import { use } from 'ember-resources';
import { pageTitle } from 'ember-page-title';
import { FirestoreQuery } from 'life-track/resources/firestore-query';
import { Timestamp } from 'firebase/firestore';
import { FirestoreDocument } from 'life-track/resources/firestore-document';
import type { Notice } from 'life-track/models/notice';

const asLocal = (date: Date) => {
  return date.toLocaleDateString();
};

export interface NoticesSignature {
  Element: HTMLDivElement;
}

export default class Notices extends Component<NoticesSignature> {
  // Only show notices where the current date is between startAt and endAt.
  // @use currentNotices = FirestoreQuery('notices', {
  //   name: 'current notices',
  //   limit: 10,
  //   orderBy: [['startAt', 'asc']],
  //   where: [
  //     ['startAt', '<', Timestamp.fromDate(new Date())],
  //     ['endAt', '>', Timestamp.fromDate(new Date())],
  //   ],
  //   verbose: true,
  // });
  currentNotices: Notice[] = [];

  @use oneNotice = FirestoreDocument('notices', 'friend', { verbose: true });
  @use theUser = FirestoreDocument(
    'app-users',
    'KwAMsoSn1EVkFruCkdQjdAyX7Amo',
    {
      verbose: true,
    }
  );

  <template>
    {{pageTitle "Notices"}}
    <div ...attributes>

      {{#if this.oneNotice}}
        ONE NOTICE:
        {{this.oneNotice.text}}
      {{else}}
        (nothing)
      {{/if}}

      <hr />
      <hr />

      User setup?
      {{this.theUser.isSetup}}

      <hr />
      <hr />

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
