import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { dataFromEvent } from 'ember-primitives/components/form';
import type { GlucoseMeasurementInput } from '#app/models/measurements/glucose.ts';
import { collections } from '#app/models/collections.ts';
import { service } from '@ember/service';
import type FirebaseService from '#app/services/firebase.ts';
import type { FlashMessagesService } from 'ember-cli-flash';
import InputNumber from '#app/components/input-number.gts';
import type RouterService from '@ember/routing/router-service';
import { parseTimeToDate, initTimePicker } from '#app/utils/timepicker.ts';

interface NewGlucoseSignature {
  Element: HTMLDivElement;
}

export default class NewGlucose extends Component<NewGlucoseSignature> {
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

    const updateData: GlucoseMeasurementInput = {
      value: Number(formData.value),
      timestamp,
    };

    try {
      await collections['app-users'](this.firebase.uid).glucoses.add(
        updateData
      );
      this.flashMessages.success('Glucose added');
      this.router.transitionTo('authenticated.new-measurement');
    } catch (e) {
      this.flashMessages.danger('Error adding glucose measurement');
      console.error('attempted data', updateData, e);
    }
  };

  get prefillValues() {
    return {
      value: '150',
      time: '',
    };
  }

  <template>
    {{pageTitle "New Glucose"}}
    <div ...attributes>

      <form {{on "submit" this.handleSubmit}}>
        <div class="text-2xl font-bold text-center">Glucose</div>
        <div class="flex flex-col">
          <label for="value" class="text-center italic text-sm">mg/dL</label>
          <InputNumber @name="value" @value={{this.prefillValues.value}} />
        </div>

        <div class="text-2xl font-bold text-center mt-4">Time</div>
        <div class="w-full flex flex-row justify-center">
          <label for="time" class="sr-only">when</label>
          <input
            class="bg-primary text-primary-content font-bold text-center rounded-full text-5xl"
            id="time"
            name="time"
            type="text"
            placeholder="Now"
            value={{this.prefillValues.time}}
            autocomplete="off"
            {{initTimePicker}}
          />
        </div>

        <button
          type="submit"
          class="btn btn-secondary btn-xl w-full mt-10"
        >Save</button>
      </form>
    </div>
  </template>
}
