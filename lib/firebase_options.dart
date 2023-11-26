// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDZhFuWEF94z3SKzAkgkKQbhM1fEMjA4gI',
    appId: '1:373296758854:web:3925ac3db49ec3ac6e8a47',
    messagingSenderId: '373296758854',
    projectId: 'simple-flutter-form',
    authDomain: 'simple-flutter-form.firebaseapp.com',
    storageBucket: 'simple-flutter-form.appspot.com',
    measurementId: 'G-T9ZLGZXDS2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6CPOCjkF90CUJL-goxy7XsPAptTkv5Ak',
    appId: '1:373296758854:android:964c6cc768bf91ed6e8a47',
    messagingSenderId: '373296758854',
    projectId: 'simple-flutter-form',
    storageBucket: 'simple-flutter-form.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAd0vt6V8qhdEa0GWP1JzL1PuxxrYqWqLA',
    appId: '1:373296758854:ios:4fdfa22727a58d3e6e8a47',
    messagingSenderId: '373296758854',
    projectId: 'simple-flutter-form',
    storageBucket: 'simple-flutter-form.appspot.com',
    iosBundleId: 'dev.logickoder.simpleFlutterForm',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAd0vt6V8qhdEa0GWP1JzL1PuxxrYqWqLA',
    appId: '1:373296758854:ios:937ef68ef60078036e8a47',
    messagingSenderId: '373296758854',
    projectId: 'simple-flutter-form',
    storageBucket: 'simple-flutter-form.appspot.com',
    iosBundleId: 'dev.logickoder.simpleFlutterForm.RunnerTests',
  );
}