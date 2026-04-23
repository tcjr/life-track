import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';
import { task, timeout } from 'ember-concurrency';
import cancelAll from 'ember-concurrency/helpers/cancel-all';
import { fn } from '@ember/helper';

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

  handleInput = (event: Event) => {
    const target = event.target as HTMLInputElement;
    const parsed = parseInt(target.value);
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
      this.currentValue += inc;
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
      data-component="InputNumber"
    >
      <button
        type="button"
        class="btn btn-circle btn-secondary btn-lg"
        {{on "pointerdown" (fn this.incrementBy.perform -1)}}
        {{on "pointerup" (cancelAll this.incrementBy)}}
        {{on "pointerleave" (cancelAll this.incrementBy)}}
        {{on "pointercancel" (cancelAll this.incrementBy)}}
      >-</button>
      <input
        type="text"
        name={{@name}}
        id={{@name}}
        value={{this.currentValue}}
        {{on "input" this.handleInput}}
        class="w-full bg-primary text-primary-content font-bold text-center rounded-full"
        inputmode="numeric"
        {{! NOTE: we might want to disable this and require the buttons to change the value }}
      />
      <button
        type="button"
        class="btn btn-circle btn-secondary btn-lg"
        {{on "pointerdown" (fn this.incrementBy.perform 1)}}
        {{on "pointerup" (cancelAll this.incrementBy)}}
        {{on "pointerleave" (cancelAll this.incrementBy)}}
        {{on "pointercancel" (cancelAll this.incrementBy)}}
      >+</button>
    </div>
  </template>
}
