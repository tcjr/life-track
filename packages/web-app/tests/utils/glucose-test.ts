import { describe, test, expect } from "vitest";
import {
  getGlucoseQuality,
  getGlucoseContextName,
} from "#app/utils/glucose.ts";

describe("Unit | Utility | glucose", () => {
  describe("getGlucoseQuality", () => {
    describe("post-meal context", () => {
      test("identifies low glucose (< 70)", () => {
        expect(getGlucoseQuality({ value: 69, context: "post-meal" })).toBe(
          "low",
        );
      });

      test("identifies normal glucose (70 - 179)", () => {
        expect(getGlucoseQuality({ value: 70, context: "post-meal" })).toBe(
          "normal",
        );
        expect(getGlucoseQuality({ value: 179, context: "post-meal" })).toBe(
          "normal",
        );
      });

      test("identifies elevated glucose (180 - 219)", () => {
        expect(getGlucoseQuality({ value: 180, context: "post-meal" })).toBe(
          "elevated",
        );
        expect(getGlucoseQuality({ value: 219, context: "post-meal" })).toBe(
          "elevated",
        );
      });

      test("identifies high glucose (>= 220)", () => {
        expect(getGlucoseQuality({ value: 220, context: "post-meal" })).toBe(
          "high",
        );
        expect(getGlucoseQuality({ value: 300, context: "post-meal" })).toBe(
          "high",
        );
      });
    });

    describe("fasting context", () => {
      test("identifies low glucose (< 70)", () => {
        expect(getGlucoseQuality({ value: 69, context: "fasting" })).toBe(
          "low",
        );
      });

      test("identifies normal glucose (70 - 129)", () => {
        expect(getGlucoseQuality({ value: 70, context: "fasting" })).toBe(
          "normal",
        );
        expect(getGlucoseQuality({ value: 129, context: "fasting" })).toBe(
          "normal",
        );
      });

      test("identifies elevated glucose (130 - 179)", () => {
        expect(getGlucoseQuality({ value: 130, context: "fasting" })).toBe(
          "elevated",
        );
        expect(getGlucoseQuality({ value: 179, context: "fasting" })).toBe(
          "elevated",
        );
      });

      test("identifies high glucose (>= 180)", () => {
        expect(getGlucoseQuality({ value: 180, context: "fasting" })).toBe(
          "high",
        );
        expect(getGlucoseQuality({ value: 250, context: "fasting" })).toBe(
          "high",
        );
      });
    });

    describe("other context", () => {
      test("uses fasting thresholds for other context", () => {
        expect(getGlucoseQuality({ value: 100, context: "other" })).toBe(
          "normal",
        );
      });
    });
  });

  describe("getGlucoseContextName", () => {
    test("returns correct name for fasting", () => {
      expect(getGlucoseContextName("fasting")).toBe("Fasting");
    });

    test("returns correct name for post-meal", () => {
      expect(getGlucoseContextName("post-meal")).toBe("Post-Meal");
    });

    test("returns correct name for other", () => {
      expect(getGlucoseContextName("other")).toBe("Other");
    });

    test("returns Unknown for undefined or unknown context", () => {
      expect(getGlucoseContextName(undefined)).toBe("Unknown");
      expect(getGlucoseContextName("")).toBe("Unknown");
    });
  });
});
