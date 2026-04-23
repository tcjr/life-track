import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';
import { task, timeout } from 'ember-concurrency';
import cancelAll from 'ember-concurrency/helpers/cancel-all';
import { fn } from '@ember/helper';

interface InputDecimalSignature {
  Args: {
    name: string;
    value: number | string;
    onChange?: (newValue: number, name: string) => void;
  };
  Element: HTMLDivElement;
}

const displayValue = (value: number) => {
  return value.toFixed(1);
};

export default class InputDecimal extends Component<InputDecimalSignature> {
  @tracked currentValue: number = parseFloat(this.args.value.toString());

  handleInput = (event: Event) => {
    const target = event.target as HTMLInputElement;
    const parsed = parseFloat(target.value);
    if (!isNaN(parsed)) {
      this.currentValue = parsed;
      this.args.onChange?.(this.currentValue, this.args.name);
    }
  };

  // This task lets us hold down the +/- buttons to continue to increment/decrement the value.
  // It will decrease the delay the longer it's held down, causing the rate of change to speed up.
  incrementBy = task({ drop: true }, async (inc: number) => {
    let delay = 400;
    while (true) {
      this.currentValue = Math.round((this.currentValue + inc) * 10) / 10;
      this.args.onChange?.(this.currentValue, this.args.name);
      await timeout(delay);
      delay = Math.max(50, delay * 0.8);
    }
  });

  <template>
    {{! template-lint-disable no-pointer-down-event-binding }}
    <div
      class="flex gap-2 items-center justify-between text-5xl"
      ...attributes
      data-component="InputDecimal"
    >
      <button
        type="button"
        class="btn btn-circle btn-secondary btn-lg"
        {{on "pointerdown" (fn this.incrementBy.perform -0.1)}}
        {{on "pointerup" (cancelAll this.incrementBy)}}
        {{on "pointerleave" (cancelAll this.incrementBy)}}
        {{on "pointercancel" (cancelAll this.incrementBy)}}
      >-</button>
      <input
        type="text"
        name={{@name}}
        id={{@name}}
        value={{displayValue this.currentValue}}
        {{on "input" this.handleInput}}
        step="0.1"
        class="w-full bg-primary text-primary-content font-bold text-center rounded-full"
        inputmode="decimal"
      />
      <button
        type="button"
        class="btn btn-circle btn-secondary btn-lg"
        {{on "pointerdown" (fn this.incrementBy.perform 0.1)}}
        {{on "pointerup" (cancelAll this.incrementBy)}}
        {{on "pointerleave" (cancelAll this.incrementBy)}}
        {{on "pointercancel" (cancelAll this.incrementBy)}}
      >+</button>
    </div>
  </template>
}
