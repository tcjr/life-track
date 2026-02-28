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
// import 'timepicker-ui/main.css';
import { TimepickerUI } from 'timepicker-ui';
import { modifier } from 'ember-modifier';

function parseTimeToDate(timeString: string): Date {
  const match = timeString.match(/^(\d{2}):(\d{2})\s(AM|PM)$/);

  if (!match) {
    throw new Error(
      `Invalid time format: "${timeString}". Expected "hh:mm AM/PM".`
    );
  }

  let hours = parseInt(match[1], 10);
  const minutes = parseInt(match[2], 10);
  const period = match[3];

  if (hours < 1 || hours > 12) {
    throw new Error(`Invalid hours: ${hours}. Must be between 01 and 12.`);
  }
  if (minutes < 0 || minutes > 59) {
    throw new Error(`Invalid minutes: ${minutes}. Must be between 00 and 59.`);
  }

  // Convert to 24-hour format
  if (period === 'AM') {
    if (hours === 12) hours = 0; // 12:xx AM -> 00:xx (midnight)
  } else {
    if (hours !== 12) hours += 12; // 01:xx PM -> 13:xx, but 12:xx PM stays as 12
  }

  const date = new Date();
  date.setHours(hours, minutes, 0, 0);

  return date;
}

const initTimePicker = modifier((element: HTMLInputElement) => {
  const picker = new TimepickerUI(element, {
    //labels: { time: 'Now', mobileTime: 'Now' },
  });
  picker.create();

  return () => {
    picker?.destroy();
  };
});

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
    console.log('form data', formData);

    const timestamp =
      formData.timepicker === ''
        ? new Date()
        : parseTimeToDate(String(formData.timepicker));

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
      timepicker: '',
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
        <div class="w-full flex flex-row justify-center">
          <label for="timepicker" class="sr-only">when</label>
          <input
            class="bg-primary text-primary-content font-bold text-center rounded-full text-5xl"
            id="timepicker"
            name="timepicker"
            type="text"
            placeholder="Now"
            value={{this.prefillValues.timepicker}}
            {{initTimePicker}}
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
