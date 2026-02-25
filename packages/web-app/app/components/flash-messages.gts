import Component from '@glimmer/component';
import { type FlashMessagesService } from 'ember-cli-flash';
import { service } from '@ember/service';
// import { on } from '@ember/modifier';

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

  // makeFlashSuccess = () => {
  //   this.flashMessages.success('IT worked!', { timeout: 60000 });
  // };
  // makeFlashError = () => {
  //   this.flashMessages.danger('IT worked!', { timeout: 60000 });
  // };
  // makeFlashInfo = () => {
  //   this.flashMessages.info('IT worked!', { timeout: 60000 });
  // };
  // makeFlashWarning = () => {
  //   this.flashMessages.warning('IT worked!', { timeout: 60000 });
  // };

  <template>
    {{!-- <button class="btn" {{on "click" this.makeFlashSuccess}}>Make Flash Success</button>
    <button class="btn" {{on "click" this.makeFlashError}}>Make Flash Error</button>
    <button class="btn" {{on "click" this.makeFlashInfo}}>Make Flash Info</button>
    <button class="btn" {{on "click" this.makeFlashWarning}}>Make Flash Warning</button> --}}

    {{! Toast messages appear at the bottom. The CSS takes care of the positioning. }}
    <div class="toast min-w-1/2" ...attributes>
      {{#each this.flashMessages.queue as |flash|}}
        {{#let (flashClasses flash.type) as |classes|}}
          <div class="alert alert-outline {{classes.alert}} ">
            <div>{{! don't remove}}</div>
            <div class="w-full">
              <div>{{flash.message}}</div>
              {{!-- <progress
                class="progress w-full {{classes.progress}}"
                value="40"
                max="100"
              ></progress> --}}
            </div>
            <div>{{! don't remove}}</div>
          </div>
        {{/let}}
      {{/each}}
    </div>
  </template>
}
