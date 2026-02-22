import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type FirebaseService from '#services/firebase';
import type RouterService from '@ember/routing/router-service';
import { doc, getDoc, setDoc } from 'firebase/firestore';

/**
 * If the user is not logged-in, the beforeModel hook should redirect to the
 * `login` route. This will "protect" all child routes of this one.
 */
export default class AuthenticatedRoute extends Route {
  @service declare firebase: FirebaseService;
  @service declare router: RouterService;

  async beforeModel() {
    await this.firebase.auth.authStateReady();

    if (!this.firebase.signedInUser) {
      console.log(
        '[route:authenticated] Not logged-in, redirecting to login route'
      );
      this.router.transitionTo('login');
    } else {
      console.log(
        '[route:authenticated] Logged-in, current user is %o',
        this.firebase.signedInUser
      );

      // The user is logged in, next we need to verify they have successfully
      // onboarded. We load the AppUser from the `app-users` collection and
      // ensure the isSetup flag is true. If there is no AppUser, we create it.
      // If isSetup is false, we transition to the setup-profile route.

      const uid = this.firebase.signedInUser.uid;
      // Load doc from firestore
      const docRef = doc(this.firebase.db, `app-users/${uid}`);
      const docSnap = await getDoc(docRef);

      if (docSnap.exists()) {
        const appUserData = docSnap.data();
        console.log('[route:authenticated] Found app-users doc', appUserData);
        if (appUserData.isSetup) {
          console.log('[route:authenticated] The app-user IS setup; all good');
        } else {
          console.log(
            '[route:authenticated] The app-user IS NOT setup, redirecting to onboarding'
          );
          this.router.transitionTo('setup-profile');
          return;
        }
      } else {
        console.log(
          '[route:authenticated] No app-users doc found, creating it now'
        );
        await setDoc(docRef, { isSetup: false });
        console.log(
          '[route:authenticated] app-user document created, redirecting to onboarding'
        );

        this.router.transitionTo('setup-profile');
      }
    }
  }
}
