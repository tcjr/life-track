import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';

interface InputNumberSignature {
  Args: {
    name: string;
    value: number | string;
    onChange?: (newValue: number, name: string) => void;
  };
  Element: HTMLDivElement;
}

export default class InputNumber extends Component<InputNumberSignature> {
  @tracked currentValue: number = parseInt(this.args.value.toString());

  increment = () => {
    this.currentValue++;
    this.args.onChange?.(this.currentValue, this.args.name);
  };
  decrement = () => {
    this.currentValue--;
    this.args.onChange?.(this.currentValue, this.args.name);
  };

  <template>
    <div class="flex gap-2 items-center justify-between" ...attributes>
      <button
        type="button"
        class="btn btn-circle btn-secondary btn-lg text-4xl"
        {{on "click" this.decrement}}
      >-</button>
      <input
        type="text"
        name={{@name}}
        id={{@name}}
        value={{this.currentValue}}
        class="w-full bg-primary text-primary-content text-5xl font-bold text-center rounded-full"
        inputmode="numeric"
        {{! NOTE: we might want to disable this }}
      />
      <button
        type="button"
        class="btn btn-circle btn-secondary btn-lg text-4xl"
        {{on "click" this.increment}}
      >+</button>
    </div>
  </template>
}
