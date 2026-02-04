import Service from '@ember/service';
import {
  initializeApp,
  type FirebaseApp,
  //type FirebaseOptions,
} from 'firebase/app';
import { getAuth, type Auth, connectAuthEmulator } from 'firebase/auth';
import {
  getFirestore,
  type Firestore,
  connectFirestoreEmulator,
} from 'firebase/firestore';

import { firebaseConfig } from '../config/firebase';
import type Owner from '@ember/owner';

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
  }
}

declare module '@ember/service' {
  interface Registry {
    firebase: FirebaseService;
  }
}
