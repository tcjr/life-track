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
import { parseTimeToDate } from '#app/utils/timepicker.ts';
import InputTime from '#app/components/input-time.gts';
import { getGlucoseContextName } from '#app/utils/measurements.ts';
import { eq } from 'ember-truth-helpers';

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

    const context = formData.context as GlucoseMeasurementInput['context'];

    const updateData: GlucoseMeasurementInput = {
      value: Number(formData.value),
      timestamp,
      context,
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
      context: 'fasting',
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
        <div class="">
          <label for="time" class="sr-only">when</label>
          <InputTime @name="time" @value={{this.prefillValues.time}} />
        </div>

        <div class="text-2xl font-bold text-center mt-4">Context</div>
        <div class="join w-full justify-center mt-2">
          <input
            class="join-item btn btn-xl"
            type="radio"
            name="context"
            value="fasting"
            aria-label={{getGlucoseContextName "fasting"}}
            checked={{eq this.prefillValues.context "fasting"}}
          />
          <input
            class="join-item btn btn-xl"
            type="radio"
            name="context"
            value="post-meal"
            aria-label={{getGlucoseContextName "post-meal"}}
            checked={{eq this.prefillValues.context "post-meal"}}
          />
          <input
            class="join-item btn btn-xl"
            type="radio"
            name="context"
            value="other"
            aria-label={{getGlucoseContextName "other"}}
            checked={{eq this.prefillValues.context "other"}}
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
