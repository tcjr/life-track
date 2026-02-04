import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type FirebaseService from 'life-track/services/firebase';
import { doc, getDoc } from 'firebase/firestore';

export default class ApplicationRoute extends Route {
  @service declare firebase: FirebaseService;

  beforeModel() {
    this.firebase.setup();
  }

  // This is an example of loading something from Firestore at app startup.
  async model() {
    const docRef = doc(this.firebase.db, 'notices', 'startup');
    const docSnap = await getDoc(docRef);

    if (docSnap.exists()) {
      return { notices: [docSnap.data()] };
    } else {
      console.log('No startup notice found');
      return { notices: [] };
    }
  }
}
