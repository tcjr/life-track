export default {
  plugins: [],
  singleQuote: true,
  overrides: [
    {
      files: ['*.js', '*.ts', '*.cjs', '.mjs', '.cts', '.mts', '.cts'],
      options: {
        trailingComma: 'es5',
      },
    },
    {
      files: ['*.html'],
      options: {
        singleQuote: false,
      },
    },
    {
      files: ['*.json'],
      options: {
        singleQuote: false,
      },
    },
  ],
};
