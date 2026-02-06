import EmberRouter from '@embroider/router';
import config from 'life-track/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('index');
  this.route('login');

  // The authenticated route is a parent route that requires authentication.
  this.route('authenticated', { path: '' }, function () {
    this.route('index');
    this.route('settings');
    this.route('notices');
  });
});
