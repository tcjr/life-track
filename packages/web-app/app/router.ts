import EmberRouter from '@embroider/router';
import config from '#app/config/environment';
import { properLinks } from 'ember-primitives/proper-links';

@properLinks
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('login');
  this.route('setup-profile');

  // The authenticated route is a parent route that requires authentication.
  this.route('authenticated', { path: '' }, function () {
    this.route('settings');
    this.route('notices');
    this.route('measurements');
    this.route('new-measurement');
    this.route('new-bp');
    this.route('new-glucose');
  });
});
