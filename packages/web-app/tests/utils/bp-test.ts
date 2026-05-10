import { describe, test, expect } from 'vitest';
import { getBpQuality } from '#app/utils/bp.ts';

describe('Unit | Utility | bp', () => {
  describe('getBpQuality', () => {
    test('identifies hypertension-crisis', () => {
      expect(getBpQuality({ systolic: 181, diastolic: 80 })).toBe(
        'hypertension-crisis'
      );
      expect(getBpQuality({ systolic: 120, diastolic: 121 })).toBe(
        'hypertension-crisis'
      );
      expect(getBpQuality({ systolic: 181, diastolic: 121 })).toBe(
        'hypertension-crisis'
      );
    });

    test('identifies hypertension-2', () => {
      expect(getBpQuality({ systolic: 140, diastolic: 80 })).toBe(
        'hypertension-2'
      );
      expect(getBpQuality({ systolic: 120, diastolic: 90 })).toBe(
        'hypertension-2'
      );
      expect(getBpQuality({ systolic: 140, diastolic: 90 })).toBe(
        'hypertension-2'
      );
      // Just below crisis
      expect(getBpQuality({ systolic: 180, diastolic: 120 })).toBe(
        'hypertension-2'
      );
    });

    test('identifies hypertension-1', () => {
      expect(getBpQuality({ systolic: 130, diastolic: 70 })).toBe(
        'hypertension-1'
      );
      expect(getBpQuality({ systolic: 110, diastolic: 80 })).toBe(
        'hypertension-1'
      );
      expect(getBpQuality({ systolic: 130, diastolic: 80 })).toBe(
        'hypertension-1'
      );
      // Just below hypertension-2
      expect(getBpQuality({ systolic: 139, diastolic: 89 })).toBe(
        'hypertension-1'
      );
    });

    test('identifies elevated', () => {
      expect(getBpQuality({ systolic: 120, diastolic: 79 })).toBe('elevated');
      expect(getBpQuality({ systolic: 129, diastolic: 70 })).toBe('elevated');
    });

    test('identifies low', () => {
      expect(getBpQuality({ systolic: 89, diastolic: 70 })).toBe('low');
      expect(getBpQuality({ systolic: 100, diastolic: 59 })).toBe('low');
      expect(getBpQuality({ systolic: 89, diastolic: 59 })).toBe('low');
    });

    test('identifies normal', () => {
      expect(getBpQuality({ systolic: 110, diastolic: 70 })).toBe('normal');
      expect(getBpQuality({ systolic: 90, diastolic: 60 })).toBe('normal');
      expect(getBpQuality({ systolic: 119, diastolic: 79 })).toBe('normal');
    });

    test('precedence: high BP conditions take precedence over low BP conditions', () => {
      // Systolic is elevated (>= 120), diastolic is low (< 60)
      // According to implementation:
      // if (systolic >= 120 && diastolic < 80) return 'elevated';
      // So it should be 'elevated'
      expect(getBpQuality({ systolic: 125, diastolic: 50 })).toBe('elevated');
    });
  });
});
