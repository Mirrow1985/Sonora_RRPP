// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AAIzaSyBwelQtIMq_biXoCRKy1SjFUyLtsn56_yE',
    appId: '1:312939314449:android:8297af71682e26e38620b0',
    messagingSenderId: '312939314449',
    projectId: 'authfirebase-73e37',
    storageBucket: 'authfirebase-73e37.firebasestorage.app',
    iosBundleId: 'com.example.loginSignup',

  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZtPOjYiwrjokBUGErIUhQoCy7og1JOkY',
    appId: '1:312939314449:ios:7094689b934952028620b0',
    messagingSenderId: '312939314449',
    projectId: 'authfirebase-73e37',
    storageBucket: 'authfirebase-73e37.firebasestorage.app',
    iosBundleId: 'com.example.loginSignup',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZtPOjYiwrjokBUGErIUhQoCy7og1JOkY',
    appId: '1:312939314449:ios:367d9bf1035ee4aa8620b0',
    messagingSenderId: '312939314449',
    projectId: 'authfirebase-73e37',
    storageBucket: 'authfirebase-73e37.firebasestorage.app',
    iosBundleId: 'com.example.authFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDvFXkxA60L0PFFH37zM3uhmvmRI1Gbkn8',
    appId: '1:312939314449:web:38425d04061fabc98620b0',
    messagingSenderId: '312939314449',
    projectId: 'authfirebase-73e37',
    authDomain: 'authfirebase-73e37.firebaseapp.com',
    storageBucket: 'authfirebase-73e37.firebasestorage.app',
  );

}