declare module '*.svg?component' {
  import type { TOC } from '@ember/component/template-only';

  interface SvgSignature {
    Element: SVGSVGElement;
    Blocks: {
      default?: [];
    };
  }

  const convertedSvgComponent: TOC<SvgSignature>;
  export default convertedSvgComponent;
}
