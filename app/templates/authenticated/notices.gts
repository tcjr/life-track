import Component from '@glimmer/component';
import { use } from 'ember-resources';
import { pageTitle } from 'ember-page-title';
import { FirestoreQuery } from 'life-track/resources/firestore-query';
import { Timestamp } from 'firebase/firestore';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

const asLocal = (date: Date) => {
  return date.toLocaleDateString();
};

export interface NoticesSignature {
  Element: HTMLDivElement;
}

// This page is a way for me to test out the FirestoreQuery resource.

export default class Notices extends Component<NoticesSignature> {
  @tracked targetDate = new Date();

  // Only show notices where the current date is between validFrom and validTo.
  @use currentNotices = FirestoreQuery('notices', () => ({
    name: 'current notices',
    limit: 10,
    orderBy: [['validFrom', 'asc']],
    where: [
      ['validFrom', '<', Timestamp.fromDate(this.targetDate)],
      ['validTo', '>', Timestamp.fromDate(this.targetDate)],
    ],
    verbose: true,
  }));

  addWeek = () => {
    const MS_WEEK = 7 * 24 * 60 * 60 * 1000;
    console.log('adding week');
    this.targetDate = new Date(this.targetDate.getTime() + MS_WEEK);
  };

  <template>
    {{pageTitle "Notices"}}
    <div ...attributes>

      <div class="p-4 pb-2 tracking-wide">Notices valid on
        {{asLocal this.targetDate}}
        <button type="button" class="btn btn-sm" {{on "click" this.addWeek}}>
          Add a week
        </button>
      </div>

      <ul class="list bg-base-100 rounded-box shadow-md">
        {{#each this.currentNotices as |notice|}}

          <li class="list-row">
            <div>
              <div>{{notice.text}}</div>
              <div class="text-xs opacity-60">
                Valid from
                {{asLocal notice.validFrom}}
                through
                {{asLocal notice.validTo}}
              </div>
            </div>
          </li>

        {{else}}

          <li class="list-row">
            <div class="text-xs opacity-60">
              No notices
            </div>
          </li>
        {{/each}}
      </ul>
    </div>
  </template>
}
