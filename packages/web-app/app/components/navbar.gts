import { on } from '@ember/modifier';
import Component from '@glimmer/component';
import type { User } from 'firebase/auth';
import Menu from '#app/icons/menu.svg?component';
import Clinical from '#app/icons/clinical-fe.svg?component';
import ChartLine from '#app/icons/chart-line.svg?component';
import Settings from '#app/icons/ui-settings.svg?component';
import RegisterBook from '#app/icons/register-book.svg?component';

export interface NavbarSignature {
  Args: {
    user: User | null;
    onLogout: () => void;
  };
  Element: HTMLDivElement;
}

export default class Navbar extends Component<NavbarSignature> {
  // We trigger this whenever we click an item in the main nav. The "soft dismiss"
  // actions are done automatically.
  closeMenu = () => {
    const popover = document.getElementById('popover-main-nav');
    if (popover) {
      popover.hidePopover();
    }
  };

  <template>
    <div class="navbar bg-base-100 shadow-sm" ...attributes>

      <div class="navbar-start">
        <button
          popovertarget="popover-main-nav"
          class="btn btn-ghost btn-circle"
          type="button"
          {{! template-lint-disable no-inline-styles }}
          style="anchor-name:--anchor-main-nav"
        >
          <Menu />
        </button>
        <ul
          class="dropdown menu menu-lg bg-base-100 rounded-box z-1 mt-3 p-2 shadow w-60"
          popover
          id="popover-main-nav"
          {{! template-lint-disable no-inline-styles }}
          style="position-anchor:--anchor-main-nav"
        >
          {{#if @user}}
            <li>
              <a href="/new-measurement" {{on "click" this.closeMenu}}>
                <Clinical class="h-5 w-5" />
                Track something
              </a>
            </li>
            <li>
              <a href="/measurements" {{on "click" this.closeMenu}}>
                <RegisterBook class="h-5 w-5" />
                Measurements</a>
            </li>
            <li>
              <a href="/reports" {{on "click" this.closeMenu}}>
                <ChartLine class="h-5 w-5" />
                Reports</a>
            </li>
            <li></li>
            <li>
              <a href="/settings" {{on "click" this.closeMenu}}>
                <Settings class="h-5 w-5" />
                Settings</a>
            </li>
            <li></li>
            <li>
              <button
                type="button"
                class=""
                {{on "click" @onLogout}}
                {{on "click" this.closeMenu}}
              >
                Logout
              </button>
            </li>
          {{else}}
            {{! Logged out.  Show only login button. }}
            <li>
              <a href="/login" {{on "click" this.closeMenu}}>
                Login
              </a>
            </li>
          {{/if}}

        </ul>
      </div>

    </div>
  </template>
}
