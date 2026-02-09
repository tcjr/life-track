import type Owner from '@ember/owner';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { pageTitle } from 'ember-page-title';
import { onSnapshot, query } from 'firebase/firestore';
import { collections } from 'life-track/models/collections';
import { type Notice } from 'life-track/models/notice';

export interface SettingsSignature {
  Args: object;
  Element: HTMLDivElement;
}

export default class Settings extends Component<SettingsSignature> {
  @tracked allNotices: Notice[] = [];
  @tracked allNoticesViaQuery: Notice[] = [];
  @tracked allNoticesViaPreparedQuery: Notice[] = [];

  constructor(owner: Owner, args: SettingsSignature['Args']) {
    super(owner, args);
    const allNoticesPromise = collections.notices.findMany({
      name: 'ten notices',
      limit: 10,
    });
    allNoticesPromise.then((data) => {
      this.allNotices = data;
      console.log('allNotices ', this.allNotices);
    });

    const qsPromise = collections.notices.query({
      name: 'more stuff',
      limit: 10,
    });
    qsPromise.then((qs) => {
      console.log('qs is ', qs);
      const docs: Notice[] = [];
      qs.forEach((doc) => {
        docs.push(doc.data());
      });
      this.allNoticesViaQuery = docs;
      console.log('allNoticesViaQuery ', this.allNoticesViaQuery);
    });

    const coll = collections.notices;

    const prepared = coll.prepare({
      name: 'noticesprepared',
      limit: 10,
    });
    const preparedQuery = query(prepared);
    onSnapshot(preparedQuery, (qs) => {
      console.log('ON SNAPSHOT');
      console.log('qs is ', qs);
      const docs: Notice[] = [];
      qs.forEach((doc) => {
        docs.push(doc.data());
      });
      this.allNoticesViaPreparedQuery = docs;
      console.log(
        'allNoticesViaPreparedQuery ',
        this.allNoticesViaPreparedQuery
      );
    });
  }

  <template>
    {{pageTitle "Settings"}}
    <div ...attributes>
      <h2>Settings (authenticated)</h2>

      <ul>
        {{#each this.allNoticesViaQuery as |notice|}}
          <li>Notice: {{notice.text}}</li>
        {{/each}}
      </ul>
    </div>
  </template>
}
