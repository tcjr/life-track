/**
 * Utility to retrieve root style variables. It's useful for integrating with Chart.js.
 *
 * `getRuntimeCssVar('--color-primary') // returns "oklch(59.435% 0.077 254.027)" for example
 */
export const getRuntimeCssVar = (varName: string) => {
  const rootElement = document.documentElement;
  const computedStyles = window.getComputedStyle(rootElement);
  return computedStyles.getPropertyValue(varName).trim();
};
