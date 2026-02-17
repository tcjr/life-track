import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { dataFromEvent } from 'ember-primitives/components/form';
import type { BpMeasurementInput } from '#app/models/measurements/bp.ts';
import { collections } from '#app/models/collections.ts';
import { service } from '@ember/service';
import type FirebaseService from '#app/services/firebase.ts';
import { LinkTo } from '@ember/routing';
import type { FlashMessagesService } from 'ember-cli-flash';

interface NewBpSignature {
  // Args: {};
  Element: HTMLDivElement;
}

export default class NewBp extends Component<NewBpSignature> {
  @service declare firebase: FirebaseService;
  @service declare flashMessages: FlashMessagesService;

  handleSubmit = async (e: Event) => {
    e.preventDefault();
    const formData = dataFromEvent(e);
    const updateData: BpMeasurementInput = {
      systolic: Number(formData.systolic),
      diastolic: Number(formData.diastolic),
      heartRate: Number(formData.heartRate),
      timestamp: new Date(),
    };

    try {
      await collections['app-users'](this.firebase.uid).bps.add(updateData);
      this.flashMessages.success('BP added');
    } catch (e) {
      this.flashMessages.danger('Error adding BP measurement');
      console.log('attempted data', updateData, e);
    }
  };

  get prefillValues() {
    return {
      systolic: '120',
      diastolic: '80',
      heartRate: '70',
    };
  }

  <template>
    {{pageTitle "New BP"}}
    <div ...attributes>
      <div class="breadcrumbs text-sm">
        <ul>
          <li><LinkTo
              @route="authenticated.measurements"
            >Measurements</LinkTo></li>
          <li>Add BP</li>
        </ul>
      </div>

      <h1>New BP</h1>
      <form {{on "submit" this.handleSubmit}}>
        <label for="systolic">Systolic</label>
        <input
          type="number"
          id="systolic"
          name="systolic"
          value={{this.prefillValues.systolic}}
        />
        <label for="diastolic">Diastolic</label>
        <input
          type="number"
          id="diastolic"
          name="diastolic"
          value={{this.prefillValues.diastolic}}
        />
        <label for="heartRate">Heart Rate</label>
        <input
          type="number"
          id="heartRate"
          name="heartRate"
          value={{this.prefillValues.heartRate}}
        />
        <button type="submit" class="btn">Submit</button>
      </form>
    </div>
  </template>
}
