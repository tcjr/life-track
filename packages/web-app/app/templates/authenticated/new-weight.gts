import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { dataFromEvent } from 'ember-primitives/components/form';
import type { WeightMeasurementInput } from '#app/models/measurements/weight.ts';
import { collections } from '#app/models/collections.ts';
import { service } from '@ember/service';
import type FirebaseService from '#app/services/firebase.ts';
import type { FlashMessagesService } from 'ember-cli-flash';
import InputDecimal from '#app/components/input-decimal.gts';
import type RouterService from '@ember/routing/router-service';
import { parseTimeToDate } from '#app/utils/timepicker.ts';
import InputTime from '#app/components/input-time.gts';

interface NewWeightSignature {
  Element: HTMLDivElement;
}

export default class NewWeight extends Component<NewWeightSignature> {
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

    const updateData: WeightMeasurementInput = {
      value: Number(formData.value),
      timestamp,
    };

    try {
      await collections['app-users'](this.firebase.uid).weights.add(updateData);
      this.flashMessages.success('Weight added');
      this.router.transitionTo('authenticated.new-measurement');
    } catch (e) {
      this.flashMessages.danger('Error adding weight measurement');
      console.error('attempted data', updateData, e);
    }
  };

  get prefillValues() {
    return {
      value: '250',
      time: '',
    };
  }

  <template>
    {{pageTitle "New Weight"}}
    <div ...attributes>

      <form {{on "submit" this.handleSubmit}}>
        <div class="text-2xl font-bold text-center">Weight</div>
        <div class="flex flex-col">
          <label for="value" class="text-center italic text-sm">lbs</label>
          <InputDecimal @name="value" @value={{this.prefillValues.value}} />
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
