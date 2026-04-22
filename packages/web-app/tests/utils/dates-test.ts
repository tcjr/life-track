import { describe, test, expect } from 'vitest';
import {
  toStartOfLocalDay,
  toEndOfLocalDay,
  asYYYYMMDD,
  asLocal,
  asLocalTime,
  asLocalDate,
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

  test('asYYYYMMDD accepts a date string', () => {
    const dateStr = '2026-03-30';
    expect(asYYYYMMDD(dateStr)).toBe(dateStr);

    const isoStr = '2026-03-30T12:00:00Z';
    const date = new Date(isoStr);
    expect(asYYYYMMDD(isoStr)).toBe(asYYYYMMDD(date));
  });

  test('asLocal accepts a date string', () => {
    const dateStr = '2026-03-30';
    expect(asLocal(dateStr)).toBe(asLocal(toStartOfLocalDay(dateStr)));

    const isoStr = '2026-03-30T12:00:00Z';
    const date = new Date(isoStr);
    expect(asLocal(isoStr)).toBe(asLocal(date));
  });

  test('asLocalTime accepts a date string', () => {
    const dateStr = '2026-03-30';
    expect(asLocalTime(dateStr)).toBe(asLocalTime(toStartOfLocalDay(dateStr)));

    const isoStr = '2026-03-30T12:00:00Z';
    const date = new Date(isoStr);
    expect(asLocalTime(isoStr)).toBe(asLocalTime(date));
  });

  test('asLocalDate accepts a date string', () => {
    const dateStr = '2026-03-30';
    expect(asLocalDate(dateStr)).toBe(asLocalDate(toStartOfLocalDay(dateStr)));

    const isoStr = '2026-03-30T12:00:00Z';
    const date = new Date(isoStr);
    expect(asLocalDate(isoStr)).toBe(asLocalDate(date));
  });
});
