import Component from '@glimmer/component';

interface AnythingSignature {
  Args: {
    value: unknown;
  };
  Element: HTMLDivElement;
}

export default class Anything extends Component<AnythingSignature> {
  <template>
    <div class="inline-block border border-base-content">
      [Unknown]
    </div>
  </template>
}
