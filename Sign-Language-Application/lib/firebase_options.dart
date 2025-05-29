// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS - '
              'reconfigure via FlutterFire CLI.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS - '
              'reconfigure via FlutterFire CLI.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows - '
              'reconfigure via FlutterFire CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux - '
              'reconfigure via FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-jhWLTpNG4kfCYm20ixLp0p5tiOgYDk8',
    appId: '1:580078063282:android:9f9704a1da6afe51cf43ab',
    messagingSenderId: '580078063282',
    projectId: 'signlanguageapp-37c45',
    storageBucket: 'signlanguageapp-37c45.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCkmAfgz0fWoWGdOYin8_v-u8ZJokrUMA4',
    appId: '1:580078063282:web:a14ee6aa236b67c2cf43ab',
    messagingSenderId: '580078063282',
    projectId: 'signlanguageapp-37c45',
    authDomain: 'signlanguageapp-37c45.firebaseapp.com',
    storageBucket: 'signlanguageapp-37c45.firebasestorage.app',
    measurementId: 'G-1VDLSVCCQN',
  );
}
