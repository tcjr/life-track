import { describe, expect, vi } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { find, render } from '@ember/test-helpers';
import { screen } from '@testing-library/dom';
import { fireEvent } from 'testing-library-ember';
import InputNumber from '#components/input-number.gts';

const setup = async () => {
  const value = 10;
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
    await fireEvent.click(plus);
    expect(input.value).toBe('11');
    await Promise.all([fireEvent.click(plus), fireEvent.click(plus)]);
    expect(input.value).toBe('13');
    await Promise.all([
      fireEvent.click(minus),
      fireEvent.click(minus),
      fireEvent.click(minus),
      fireEvent.click(minus),
    ]);
    expect(input.value).toBe('9');
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
    await fireEvent.click(plus);

    expect(handleChange).toHaveBeenCalledWith(101, 'changeme');
  });
});
