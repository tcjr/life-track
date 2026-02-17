import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { dataFromEvent } from 'ember-primitives/components/form';
import type { GlucoseMeasurementInput } from '#app/models/measurements/glucose.ts';
import { collections } from '#app/models/collections.ts';
import { service } from '@ember/service';
import type FirebaseService from '#app/services/firebase.ts';
import { LinkTo } from '@ember/routing';
import type { FlashMessagesService } from 'ember-cli-flash';

interface NewGlucoseSignature {
  // Args: {};
  Element: HTMLDivElement;
}

export default class NewGlucose extends Component<NewGlucoseSignature> {
  @service declare firebase: FirebaseService;
  @service declare flashMessages: FlashMessagesService;

  handleSubmit = async (e: Event) => {
    e.preventDefault();
    const formData = dataFromEvent(e);
    const updateData: GlucoseMeasurementInput = {
      value: Number(formData.value),
      timestamp: new Date(),
    };

    try {
      await collections['app-users'](this.firebase.uid).glucoses.add(
        updateData
      );
      this.flashMessages.success('Glucose added');
    } catch (e) {
      this.flashMessages.danger('Error adding glucose measurement');
      console.log('attempted data', updateData, e);
    }
  };

  get prefillValues() {
    return {
      value: '150',
    };
  }

  <template>
    {{pageTitle "New Glucose"}}
    <div ...attributes>
      <div class="breadcrumbs text-sm">
        <ul>
          <li><LinkTo
              @route="authenticated.measurements"
            >Measurements</LinkTo></li>
          <li>Add Glucose</li>
        </ul>
      </div>

      <h1>New Glucose</h1>
      <form {{on "submit" this.handleSubmit}}>
        <label for="value">Value</label>
        <input
          type="number"
          id="value"
          name="value"
          value={{this.prefillValues.value}}
        />
        <button type="submit" class="btn">Submit</button>
      </form>
    </div>
  </template>
}
