import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import { service } from '@ember/service';
import { action } from '@ember/object';
import FirebaseService from '#services/firebase';
import { on } from '@ember/modifier';
import type RouterService from '@ember/routing/router-service';

export interface LoginSignature {
  Element: HTMLDivElement;
}

export default class Login extends Component<LoginSignature> {
  @service declare firebase: FirebaseService;
  @service declare router: RouterService;

  @action
  async login(evt: SubmitEvent) {
    evt.preventDefault();
    try {
      await this.firebase.loginWithGooglePopup();
      // Redirect to authenticated routes after successful login
      this.router.transitionTo('authenticated.index');
    } catch (error) {
      console.error('Login failed:', error);
      // TODO: Display a user-friendly error message
    }
  }

  <template>
    {{pageTitle "Login"}}
    <div ...attributes>
      <div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
        <div class="sm:mx-auto sm:w-full sm:max-w-sm">
          <h2
            class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900"
          >
            Sign in to your account
          </h2>
        </div>

        <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
          <form class="space-y-6" {{on "submit" this.login}}>
            <div>
              <button
                type="submit"
                class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
              >
                Sign in with Google
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
}
