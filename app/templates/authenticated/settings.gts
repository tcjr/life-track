import { on } from '@ember/modifier';
import { service } from '@ember/service';
import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import { use } from 'ember-resources';
import { collections } from 'life-track/models/collections';
import { FirestoreDocument } from 'life-track/resources/firestore-document';
import type FirebaseService from 'life-track/services/firebase';

function eq<T>(a: T, b: T) {
  return a === b;
}

export interface SettingsSignature {
  Element: HTMLDivElement;
}

const THEMES = ['light', 'dark', 'system'] as const;
type Theme = (typeof THEMES)[number];

export default class Settings extends Component<SettingsSignature> {
  @service declare firebase: FirebaseService;
  @use appUserDoc = FirestoreDocument(
    'app-users',
    () => this.firebase.signedInUser!.uid,
    { verbose: true }
  );

  changeTheme = async (evt: Event) => {
    const newTheme = (evt.currentTarget as HTMLInputElement).value as Theme;
    const id = this.appUserDoc._id;
    await collections['app-users'].update(id, { theme: newTheme });
    console.log('updated theme');
  };

  <template>
    {{pageTitle "Settings"}}
    <div ...attributes>
      <h2>Settings (authenticated)</h2>

      <fieldset class="fieldset">
        <legend class="fieldset-legend">Theme</legend>
        <select
          class="select"
          {{on "change" this.changeTheme}}
          aria-label="choose theme"
        >
          <option disabled>Pick a theme</option>
          {{#each THEMES as |themeName|}}
            <option
              selected={{if (eq this.appUserDoc.theme themeName) "selected"}}
            >{{themeName}}</option>
          {{/each}}
        </select>
      </fieldset>

    </div>
  </template>
}
