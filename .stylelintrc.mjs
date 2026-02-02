export default {
  extends: ['stylelint-config-standard'],
  rules: {
    'at-rule-no-unknown': [
      true,
      {
        ignoreAtRules: ['plugin'], // used by tailwind/daisy
      },
    ],
    'import-notation': null, // allows tailwindcss import
    'at-rule-empty-line-before': null,
    'custom-property-empty-line-before': null,

    // The DaisyUI themes use numbers, so "0" instead of "0deg"
    'hue-degree-notation': 'number',
  },
};
