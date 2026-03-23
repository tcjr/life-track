import { describe, expect } from 'vitest';
import { renderingTest } from 'ember-vitest';
import { render, click } from '@ember/test-helpers';
import { screen } from '@testing-library/dom';
import MonthList from '#app/components/month-list.gts';

const mockMeasurements = {
  bps: [
    {
      _id: 'bp1',
      systolic: 120,
      diastolic: 80,
      heartRate: 70,
      timestamp: new Date('2026-03-01T10:00:00Z').toISOString(),
    },
  ],
  glucoses: [
    {
      _id: 'g1',
      value: 100,
      timestamp: new Date('2026-03-01T11:00:00Z').toISOString(),
    },
  ],
};

describe('Component | MonthList', () => {
  renderingTest('it renders checkboxes', async () => {
    await render(
      <template><MonthList @measurements={{mockMeasurements}} /></template>
    );

    const bpCheckbox = screen.getByLabelText(/BP/);
    expect(bpCheckbox).toBeInTheDocument();
    expect(bpCheckbox).toBeChecked();

    const glucoseCheckbox = screen.getByLabelText(/Glucose/);
    expect(glucoseCheckbox).toBeInTheDocument();
    expect(glucoseCheckbox).toBeChecked();
  });

  renderingTest('it renders events in the calendar', async () => {
    await render(
      <template><MonthList @measurements={{mockMeasurements}} /></template>
    );

    const events = document.querySelectorAll('.ec-event');
    expect(events.length).toBe(2);

    expect(screen.getByText(/BP 120\/80/)).toBeInTheDocument();
    expect(screen.getByText(/Glucose 100/)).toBeInTheDocument();
  });

  renderingTest('it filters events when checkboxes are toggled', async () => {
    await render(
      <template><MonthList @measurements={{mockMeasurements}} /></template>
    );

    let events = document.querySelectorAll('.ec-event');
    expect(events.length).toBe(2);

    const bpCheckbox = screen.getByLabelText(/BP/);
    await click(bpCheckbox);

    events = document.querySelectorAll('.ec-event');
    expect(events.length).toBe(1);

    expect(screen.queryByText(/BP 120\/80/)).not.toBeInTheDocument();
    expect(screen.getByText(/Glucose 100/)).toBeInTheDocument();

    const glucoseCheckbox = screen.getByLabelText(/Glucose/);
    await click(glucoseCheckbox);

    events = document.querySelectorAll('.ec-event');
    expect(events.length).toBe(0);
  });
});
