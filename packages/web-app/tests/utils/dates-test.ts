import { describe, test, expect } from 'vitest';
import {
  toStartOfLocalDay,
  toEndOfLocalDay,
  asYYYYMMDD,
} from '#app/utils/dates.ts';

describe('Unit | Utility | dates', () => {
  test('toStartOfLocalDay correctly creates a date at midnight local time', () => {
    const dateStr = '2026-03-30';
    const result = toStartOfLocalDay(dateStr);

    expect(asYYYYMMDD(result)).toBe(dateStr);
    expect(result.getHours()).toBe(0);
    expect(result.getMinutes()).toBe(0);
    expect(result.getSeconds()).toBe(0);
    expect(result.getMilliseconds()).toBe(0);
  });

  test('toEndOfLocalDay correctly creates a date at 23:59:59.999 local time', () => {
    const dateStr = '2026-03-30';
    const result = toEndOfLocalDay(dateStr);

    expect(asYYYYMMDD(result)).toBe(dateStr);
    expect(result.getHours()).toBe(23);
    expect(result.getMinutes()).toBe(59);
    expect(result.getSeconds()).toBe(59);
    expect(result.getMilliseconds()).toBe(999);
  });

  test('toISOString of local start and end matches expected UTC offset', () => {
    const dateStr = '2026-03-30';
    const start = toStartOfLocalDay(dateStr);
    const end = toEndOfLocalDay(dateStr);

    const diff = end.getTime() - start.getTime();
    expect(diff).toBe(24 * 60 * 60 * 1000 - 1);

    expect(start.toISOString()).toMatch(/T/);
  });
});
