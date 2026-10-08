
// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      case TargetPlatform.iOS:
        return ios;

      case TargetPlatform.macOS:
        return macos;

      case TargetPlatform.windows:
        return windows;

      case TargetPlatform.linux:
        return linux;

      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Firebase haijawekewa configuration ya Fuchsia.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'dummy-web-api-key',
    appId: '1:000000000000:web:dummyapp',
    messagingSenderId: '000000000000',
    projectId: 'soko-letu-tz-demo',
    authDomain: 'soko-letu-tz-demo.firebaseapp.com',
    storageBucket: 'soko-letu-tz-demo.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'dummy-android-api-key',
    appId: '1:000000000000:android:dummyapp',
    messagingSenderId: '000000000000',
    projectId: 'soko-letu-tz-demo',
    storageBucket: 'soko-letu-tz-demo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'dummy-ios-api-key',
    appId: '1:000000000000:ios:dummyapp',
    messagingSenderId: '000000000000',
    projectId: 'soko-letu-tz-demo',
    iosBundleId: 'com.sokoletutz.app',
    storageBucket: 'soko-letu-tz-demo.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'dummy-macos-api-key',
    appId: '1:000000000000:ios:dummyapp',
    messagingSenderId: '000000000000',
    projectId: 'soko-letu-tz-demo',
    iosBundleId: 'com.sokoletutz.app',
    storageBucket: 'soko-letu-tz-demo.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'dummy-windows-api-key',
    appId: '1:000000000000:web:dummyapp',
    messagingSenderId: '000000000000',
    projectId: 'soko-letu-tz-demo',
    authDomain: 'soko-letu-tz-demo.firebaseapp.com',
    storageBucket: 'soko-letu-tz-demo.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'dummy-linux-api-key',
    appId: '1:000000000000:web:dummyapp',
    messagingSenderId: '000000000000',
    projectId: 'soko-letu-tz-demo',
    authDomain: 'soko-letu-tz-demo.firebaseapp.com',
    storageBucket: 'soko-letu-tz-demo.firebasestorage.app',
  );
}
