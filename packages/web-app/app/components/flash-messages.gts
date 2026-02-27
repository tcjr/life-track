import Component from '@glimmer/component';
import { type FlashMessagesService } from 'ember-cli-flash';
import { service } from '@ember/service';

const flashClasses = (flashType: string) => {
  // Utility JIT class names don't let us build them programmatically
  switch (flashType) {
    case 'success':
      return { alert: 'alert-success', progress: 'progress-success' };
    case 'error':
    case 'danger':
      return { alert: 'alert-error', progress: 'progress-error' };
    case 'warning':
      return { alert: 'alert-warning', progress: 'progress-warning' };
    case 'info':
      return { alert: 'alert-info', progress: 'progress-info' };
    default:
      return { alert: 'alert-info', progress: 'progress-info' };
  }
};

interface FlashMessagesSignature {
  Element: HTMLDivElement;
}

export default class FlashMessages extends Component<FlashMessagesSignature> {
  @service declare flashMessages: FlashMessagesService;

  <template>
    {{! Toast messages appear at the bottom. The CSS takes care of the positioning. }}
    <div class="toast toast-center toast-middle min-w-1/2" ...attributes>
      {{#each this.flashMessages.queue as |flash|}}
        {{#let (flashClasses flash.type) as |classes|}}
          <div class="alert {{classes.alert}} ">
            <div>{{! don't remove}}</div>
            <div class="w-full">
              <div>{{flash.message}}</div>
            </div>
            <div>{{! don't remove}}</div>
          </div>
        {{/let}}
      {{/each}}
    </div>
  </template>
}
