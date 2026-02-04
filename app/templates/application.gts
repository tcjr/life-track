import { on } from '@ember/modifier';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { pageTitle } from 'ember-page-title';
import { use } from 'ember-resources';
import type {
  DocumentData,
  DocumentSnapshot,
  FirestoreDataConverter,
} from 'firebase/firestore';
import { FirestoreDoc } from 'life-track/resources/firestore-doc';

interface ApplicationComponentSignature {
  Args: {
    model: {
      notices: Array<{ text: string }>;
    };
  };
}

interface Notice {
  id: string;
  text: string;
}

const noticeConverter: FirestoreDataConverter<Notice> = {
  toFirestore(notice: Notice) {
    return { text: notice.text };
  },
  fromFirestore(snapshot: DocumentSnapshot) {
    const data = snapshot.data() as DocumentData;
    const id = snapshot.id;

    return {
      id,
      text: data.text as string,
    } as Notice;
  },
};

export default class Application extends Component<ApplicationComponentSignature> {
  @use oneNotice = FirestoreDoc(() => this.inputId, noticeConverter, {
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

    {{outlet}}
  </template>
}
