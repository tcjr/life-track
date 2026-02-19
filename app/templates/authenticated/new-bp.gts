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
import InputNumber from '#components/input-number.gts';

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
      console.error('attempted data', updateData, e);
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
      <div class="breadcrumbs text-sm mb-4">
        <ul>
          <li><LinkTo
              @route="authenticated.measurements"
            >Measurements</LinkTo></li>
          <li>New Blood Pressure Measurement</li>
        </ul>
      </div>

      <form {{on "submit" this.handleSubmit}}>
        <div class="text-2xl font-bold text-center">Blood Pressure</div>
        <div class="flex flex-col">
          <label for="systolic" class="text-center italic text-sm">systolic mmHg</label>
          <InputNumber
            @name="systolic"
            @value={{this.prefillValues.systolic}}
          />
        </div>
        <div class="flex flex-col mt-2">
          <label for="diastolic" class="text-center italic text-sm">diastolic
            mmHg</label>
          <InputNumber
            @name="diastolic"
            @value={{this.prefillValues.diastolic}}
          />
        </div>

        <div class="text-2xl font-bold text-center mt-4">Heart Rate</div>
        <div class="text-center italic text-sm">bpm</div>
        <div>
          <label for="heartRate" class="sr-only">heart rate</label>
          <InputNumber
            @name="heartRate"
            @value={{this.prefillValues.heartRate}}
          />
        </div>
        <button
          type="submit"
          class="btn btn-secondary btn-xl w-full mt-6"
        >Save</button>
      </form>
    </div>
  </template>
}
