import { on } from '@ember/modifier';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { pageTitle } from 'ember-page-title';
import { use } from 'ember-resources';
// import { FirestoreBasicQuery } from 'life-track/resources/firestore-basic-query';
import { FirestoreCollection } from 'life-track/resources/firestore-collection';
import { FirestoreDoc } from 'life-track/resources/firestore-doc';
import { noticeConverter } from 'life-track/models/notice';

interface ApplicationComponentSignature {
  Args: {
    model: {
      notices: Array<{ text: string }>;
    };
  };
}

export default class Application extends Component<ApplicationComponentSignature> {
  @use oneNotice = FirestoreDoc(() => this.inputId, noticeConverter, {
    verbose: true,
  });

  @use allNotices = FirestoreCollection('notices', noticeConverter, {
    verbose: true,
  });

  @tracked inputId: string = 'notices/unknown';

  updateNoticeId = (event: Event) => {
    const input = event.target as HTMLInputElement;
    const noticeId = input.value;
    this.inputId = `notices/${noticeId || 'unknown'}`;
  };

  <template>
    {{pageTitle "LifeTrack"}}
    <h2 class="bg-primary text-primary-content">Welcome to Ember</h2>

    {{#each @model.notices as |notice|}}
      NOTICE:
      {{notice.text}}
    {{/each}}

    <hr />
    <input
      aria-label="notice id"
      type="text"
      placeholder="notice id"
      {{on "input" this.updateNoticeId}}
    />
    <hr />
    {{#if this.oneNotice}}
      ONE NOTICE:
      {{this.oneNotice.text}}
      ({{this.oneNotice.id}})
    {{else}}
      NO NOTICE
    {{/if}}

    <hr />

    {{#let (FirestoreDoc "notices/friend" noticeConverter) as |notice|}}
      SOMETHING:
      {{#if notice}}
        {{notice.text}}
        ({{notice.id}})
      {{else}}
        NO NOTICE
      {{/if}}
    {{/let}}

    <hr />
    ALL NOTICES (with text field):
    {{#if this.allNotices}}
      <ul>
        {{#each this.allNotices as |notice|}}
          <li>
            {{notice.text}}
            ({{notice.id}})
          </li>
        {{/each}}
      </ul>
    {{else}}
      NO NOTICES MATCH QUERY
    {{/if}}

    {{outlet}}
  </template>
}
