import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { dataFromEvent } from 'ember-primitives/components/form';
import type { BpMeasurementInput } from '#app/models/measurements/bp.ts';
import { collections } from '#app/models/collections.ts';
import { service } from '@ember/service';
import type FirebaseService from '#app/services/firebase.ts';
import type { FlashMessagesService } from 'ember-cli-flash';
import InputNumber from '#components/input-number.gts';
import type RouterService from '@ember/routing/router-service';
import { parseTimeToDate } from '#app/utils/timepicker.ts';
import InputTime from '#app/components/input-time.gts';

interface NewBpSignature {
  Element: HTMLDivElement;
}

export default class NewBp extends Component<NewBpSignature> {
  @service declare firebase: FirebaseService;
  @service declare flashMessages: FlashMessagesService;
  @service declare router: RouterService;

  handleSubmit = async (e: Event) => {
    e.preventDefault();
    const formData = dataFromEvent(e);

    const timestamp =
      formData.time === ''
        ? new Date()
        : parseTimeToDate(String(formData.time));

    const updateData: BpMeasurementInput = {
      systolic: Number(formData.systolic),
      diastolic: Number(formData.diastolic),
      heartRate: Number(formData.heartRate),
      timestamp,
    };

    try {
      await collections['app-users'](this.firebase.uid).bps.add(updateData);
      this.flashMessages.success('BP added');
      this.router.transitionTo('authenticated.new-measurement');
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
      time: '',
    };
  }

  <template>
    {{pageTitle "New BP"}}
    <div ...attributes>

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

        <div class="text-2xl font-bold text-center mt-4">Time</div>
        <div class="">
          <label for="time" class="sr-only">when</label>
          <InputTime @name="time" @value={{this.prefillValues.time}} />
        </div>

        <button
          type="submit"
          class="btn btn-secondary btn-xl w-full mt-10"
        >Save</button>
      </form>
    </div>
  </template>
}
