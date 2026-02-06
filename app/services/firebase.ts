import Service from '@ember/service';
import {
  initializeApp,
  type FirebaseApp,
  //type FirebaseOptions,
} from 'firebase/app';
import {
  getAuth,
  type Auth,
  connectAuthEmulator,
  type User,
  onAuthStateChanged,
  GoogleAuthProvider,
  signInWithPopup,
  signOut,
} from 'firebase/auth';
import {
  getFirestore,
  type Firestore,
  connectFirestoreEmulator,
} from 'firebase/firestore';

import { firebaseConfig } from '../config/firebase';
import type Owner from '@ember/owner';
import { tracked } from '@glimmer/tracking';

export default class FirebaseService extends Service {
  app: FirebaseApp;
  auth: Auth;
  db: Firestore;

  constructor(owner: Owner) {
    super(owner);

    // Initialize Firebase
    this.app = initializeApp(firebaseConfig);
    console.log(
      `[service:firebase]🔥 Initialized Firebase app: ${this.app.name}`
    );

    // Initialize Firebase Authentication and get a reference to the service
    this.auth = getAuth(this.app);

    // Initialize Cloud Firestore and get a reference to the service
    this.db = getFirestore(this.app);
  }

  // This method bootstraps the use of emulators based on environment variables.
  // It's currently synchrnous, but might be made asynchronous if we want to
  // do something like load a remote startup file.
  setup() {
    if (import.meta.env.VITE_USE_AUTH_EMULATOR === 'true') {
      connectAuthEmulator(this.auth, 'http://localhost:9099');
      console.log('[service:firebase]🚫 Using Auth emulator, port 9099');
    } else {
      console.log('[service:firebase]🔥 Using Auth production (no emulation)');
    }

    if (import.meta.env.VITE_USE_FIRESTORE_EMULATOR === 'true') {
      connectFirestoreEmulator(this.db, 'localhost', 8080);
      console.log('[service:firebase]🚫 Using Firestore emulator, port 8080');
    } else {
      console.log(
        '[service:firebase]🔥 Using Firestore production (no emulation)'
      );
    }

    // listen for changes to the user's sign-in state
    console.log('[service:firebase]🔥 Listening for login changes');

    onAuthStateChanged(this.auth, (user) => {
      if (user) {
        // User is signed in.
        console.log('[service:firebase]🔥 User is signed in', user);
        this.signedInUser = user;
      } else {
        // User is signed out.
        console.log('[service:firebase]🔥 User is signed out');
        this.signedInUser = null;
      }
    });
  }

  async loginWithGooglePopup() {
    const provider = new GoogleAuthProvider();
    try {
      await signInWithPopup(this.auth, provider);
      console.log('[service:firebase] Google login successful');
    } catch (error) {
      console.error('[service:firebase] Google login failed', error);
      // You might want to throw the error or handle it more gracefully in the UI
      throw error;
    }
  }

  async logout() {
    try {
      await signOut(this.auth);
      console.log('[service:firebase] User signed out');
    } catch (error) {
      console.error('[service:firebase] Logout failed', error);
      throw error;
    }
  }

  @tracked signedInUser: User | null = null;
}

declare module '@ember/service' {
  interface Registry {
    firebase: FirebaseService;
  }
}
