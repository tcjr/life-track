import { describe, expect, vi } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { find, render } from '@ember/test-helpers';
import { screen } from '@testing-library/dom';
import { fireEvent } from 'testing-library-ember';
import InputDecimal from '#components/input-decimal.gts';

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
      <InputDecimal @name="yada" @value={{value}} />
    </template>
  );

  const input: HTMLInputElement = await screen.findByLabelText('My Yada');
  const plus = await screen.findByText('+');
  const minus = await screen.findByText('-');

  return { input, plus, minus };
};

describe('Component | InputDecimal', () => {
  renderingTest('it renders all the parts', async () => {
    const { input } = await setup();
    expect(input.value).toBe('10.0');
  });

  renderingTest('plus and minus work', async () => {
    const { input, plus, minus } = await setup();

    expect(input.value).toBe('10.0');
    await mouseClick(plus);
    expect(input.value).toBe('10.1');
    await mouseClick(plus);
    await mouseClick(plus);
    expect(input.value).toBe('10.3');
    await mouseClick(minus);
    await mouseClick(minus);
    await mouseClick(minus);
    await mouseClick(minus);
    expect(input.value).toBe('9.9');
  });

  renderingTest('manual input works', async () => {
    const { input, plus } = await setup();

    fireEvent.input(input, { target: { value: '15.5' } });
    expect(input.value).toBe('15.5');

    await mouseClick(plus);
    expect(input.value).toBe('15.6');
  });

  renderingTest('it calls onChange on button click', async () => {
    const value = 100;
    const handleChange = vi.fn();

    await render(
      <template>
        <InputDecimal
          @name="changeme"
          @value={{value}}
          @onChange={{handleChange}}
        />
      </template>
    );
    const input = find('input');
    expect(input!.value).toBe('100.0');

    const plus = await screen.findByText('+');
    await mouseClick(plus);

    expect(handleChange).toHaveBeenCalledWith(100.1, 'changeme');
  });

  renderingTest('it calls onChange on manual input', async () => {
    const value = 100;
    const handleChange = vi.fn();

    await render(
      <template>
        <InputDecimal
          @name="changeme"
          @value={{value}}
          @onChange={{handleChange}}
        />
      </template>
    );

    const input: HTMLInputElement = await screen.findByRole('textbox');
    fireEvent.input(input, { target: { value: '105.5' } });

    expect(handleChange).toHaveBeenCalledWith(105.5, 'changeme');
  });
});
