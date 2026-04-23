import { describe, expect, vi } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { find, render } from '@ember/test-helpers';
import { screen } from '@testing-library/dom';
import { fireEvent } from 'testing-library-ember';
import InputNumber from '#components/input-number.gts';

declare module 'vitest' {
  interface Assertion {
    toBeNear(expected: string): void;
  }
}

expect.extend({
  toBeNear(received: string, expected: string) {
    const pass = Math.abs(parseFloat(received) - parseFloat(expected)) < 2;
    const { isNot } = this;
    return {
      pass,
      message: () =>
        `${received} is${isNot ? ' not' : ''} near enough to ${expected}`,
    };
  },
});

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

const mouseClick = async (elem: Element, pressLength = 5) => {
  fireEvent.pointerDown(elem);
  await delay(pressLength);
  fireEvent.pointerUp(elem);
};

const setup = async (initialValue = 10) => {
  const value = initialValue;
  await render(
    <template>
      <label for="yada">My Yada</label>
      <InputNumber @name="yada" @value={{value}} />
    </template>
  );

  const input: HTMLInputElement = await screen.findByLabelText('My Yada');
  const plus = await screen.findByText('+');
  const minus = await screen.findByText('-');

  return { input, plus, minus };
};

describe('Component | InputNumber', () => {
  renderingTest('it renders all the parts', async () => {
    const { input } = await setup();
    expect(input.value).toBe('10');
  });

  renderingTest('plus and minus work', async () => {
    const { input, plus, minus } = await setup();

    expect(input.value).toBe('10');
    await mouseClick(plus);
    expect(input.value).toBe('11');
    await mouseClick(plus);
    await mouseClick(plus);
    expect(input.value).toBe('13');
    await mouseClick(minus);
    await mouseClick(minus);
    await mouseClick(minus);
    await mouseClick(minus);
    expect(input.value).toBe('9');
  });

  // The component increments (or decrements) the value, then has a diminishing
  // internal delay that starts at 400ms and decreases by 80% in a loop until it
  // reaches 50ms.
  //
  // pass value sleep (ms) total time (ms)
  // ---- ----- ---------- ----------------
  //  1   +/-1     400         400
  //  2   +/-2     320         720
  //  3   +/-3     256         976
  //  4   +/-4     204.8      1180.8
  //  5   +/-5     163.84     1344.64
  //  6   +/-6     131.07     1475.71
  //  7   +/-7     104.86     1580.57
  //  8   +/-8      84.67     1665.26
  //  9   +/-9      67.11     1732.37
  // 10   +/-10     53.69     1786.06
  // 11   +/-11     50        1836.06
  // 12   +/-12     50        1886.06
  // ...
  // 20   +/-20     50        2286.06

  // So, if you press for 100ms, then it will be in the 4th sleep pass and the
  // value will be +/-4.  This table is just the sleep delay, it doesn't take
  // into account the intrinsic time for whatever instructions are being
  // executed, so it's difficult to be extremely precise. Therefore, these test
  // use a "close enough" value for long press.

  renderingTest('long press works', async () => {
    const { input, plus, minus } = await setup(100);

    expect(input.value).toBe('100');
    await mouseClick(plus, 1000);
    expect(input.value).toBe('104');
    await mouseClick(minus, 1000);
    expect(input.value).toBe('100');
  });

  renderingTest('longer press works', async () => {
    const { input, plus } = await setup(100);

    expect(input.value).toBe('100');
    await mouseClick(plus, 2280);
    expect(input.value).toBeNear('120');
  });

  renderingTest('it calls onChange', async () => {
    const value = 100;
    const handleChange = vi.fn();

    await render(
      <template>
        <InputNumber
          @name="changeme"
          @value={{value}}
          @onChange={{handleChange}}
        />
      </template>
    );
    const input = find('input');
    expect(input!.value).toBe('100');

    const plus = await screen.findByText('+');
    await mouseClick(plus);

    expect(handleChange).toHaveBeenCalledWith(101, 'changeme');
  });

  renderingTest('manual input works', async () => {
    const { input, plus } = await setup();

    fireEvent.input(input, { target: { value: '15' } });
    expect(input.value).toBe('15');

    await mouseClick(plus);
    expect(input.value).toBe('16');
  });

  renderingTest('it calls onChange on manual input', async () => {
    const value = 100;
    const handleChange = vi.fn();

    await render(
      <template>
        <InputNumber
          @name="changeme"
          @value={{value}}
          @onChange={{handleChange}}
        />
      </template>
    );

    const input: HTMLInputElement = await screen.findByRole('textbox');
    fireEvent.input(input, { target: { value: '105' } });

    expect(handleChange).toHaveBeenCalledWith(105, 'changeme');
  });
});
