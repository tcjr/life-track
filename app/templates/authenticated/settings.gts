import { on } from '@ember/modifier';
import { service } from '@ember/service';
import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import type FirebaseService from '#services/firebase';
import type { AppUserInput } from '#models/app-user';
import Doc from '#components/doc';
import { fn } from '@ember/helper';

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

  onFormSubmit = async (
    docOps: { update: (data: Partial<AppUserInput>) => Promise<void> },
    evt: Event
  ) => {
    evt.preventDefault();

    const formData = new FormData(evt.currentTarget as HTMLFormElement);
    const data = Object.fromEntries(formData.entries());

    // We want to be sure to only update certain fields
    const dataToUpdate = { theme: data.theme as Theme };

    // Use the document-specific updater to change the data.
    await docOps.update(dataToUpdate);

    console.log(`${this.uid} updated`);
  };

  <template>
    {{pageTitle "Settings"}}
    <div ...attributes>
      <h2>Settings (authenticated)</h2>

      <hr />

      <Doc @collection="app-users" @id="{{this.uid}}">
        <:error>
          Error!
        </:error>
        <:loaded as |appUser ops|>
          {{!log "ref for the doc is" (ops.ref)}}

          <form {{on "submit" (fn this.onFormSubmit ops)}}>
            <fieldset class="fieldset">
              <legend class="fieldset-legend">Theme</legend>
              <select class="select" name="theme" aria-label="choose theme">
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
