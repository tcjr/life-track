import { on } from '@ember/modifier';
import { service } from '@ember/service';
import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import { collections } from '#models/collections';
import type FirebaseService from '#services/firebase';
import Doc from '#components/doc';

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

  get uid() {
    return this.firebase.signedInUser!.uid || '';
  }

  onFormSubmit = async (evt: Event) => {
    evt.preventDefault();
    const formData = new FormData(evt.currentTarget as HTMLFormElement);
    const data = Object.fromEntries(formData.entries());
    // console.log('data', data);
    // We want to be sure to only update certain fields
    const dataToUpdate = { theme: data.theme as Theme };

    await collections['app-users'].update(this.uid, dataToUpdate);
    console.log(`${this.uid} updated`);
  };

  <template>
    {{pageTitle "Settings"}}
    <div ...attributes>
      <h2>Settings (authenticated)</h2>

      <hr />

      <Doc @collection="app-users" @id={{this.uid}}>
        <:loaded as |appUser|>

          <form {{on "submit" this.onFormSubmit}}>

            <fieldset class="fieldset">
              <legend class="fieldset-legend">Theme</legend>
              <select
                class="select"
                {{!on "change" this.changeTheme}}
                name="theme"
                aria-label="choose theme"
              >
                <option disabled>Pick a theme</option>
                {{#each THEMES as |themeName|}}
                  <option
                    selected={{if (eq appUser.theme themeName) "selected"}}
                  >{{themeName}}</option>
                {{/each}}
              </select>
            </fieldset>
            <button type="submit" class="btn">Save</button>
          </form>
        </:loaded>
      </Doc>

    </div>
  </template>
}
