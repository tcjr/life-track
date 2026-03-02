import Component from '@glimmer/component';
import { initTimePicker } from '#app/utils/timepicker.ts';

interface InputTimeSignature {
  Args: {
    name: string;
    value: string;
  };
  Element: HTMLInputElement;
}

export default class InputTime extends Component<InputTimeSignature> {
  <template>
    <input
      class="bg-primary text-primary-content font-bold text-center rounded-full w-full text-5xl"
      id="time"
      name="time"
      type="text"
      placeholder="Now"
      value={{@value}}
      autocomplete="off"
      {{initTimePicker}}
      ...attributes
    />
  </template>
}
