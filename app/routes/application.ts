import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type FirebaseService from 'life-track/services/firebase';

export default class ApplicationRoute extends Route {
  @service declare firebase: FirebaseService;

  beforeModel() {
    this.firebase.setup();
  }
}
