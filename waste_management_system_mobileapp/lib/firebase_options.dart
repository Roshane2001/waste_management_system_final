// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD9CApePbzdHg6jFqMaKBOCVB7C7G8efgE',
    appId: '1:455331973314:web:7f4e252c2956738462535b',
    messagingSenderId: '455331973314',
    projectId: 'wastemanagement-60c33',
    authDomain: 'wastemanagement-60c33.firebaseapp.com',
    storageBucket: 'wastemanagement-60c33.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfuhkFaWb8JNVGTXxe6s_D7Keb0L1_ZyU',
    appId: '1:455331973314:android:2d9604a150e5de4262535b',
    messagingSenderId: '455331973314',
    projectId: 'wastemanagement-60c33',
    storageBucket: 'wastemanagement-60c33.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcwQAMJ1dx__4PLZfPVF3jT7XCJbFokWc',
    appId: '1:455331973314:ios:2b885e96b2de227462535b',
    messagingSenderId: '455331973314',
    projectId: 'wastemanagement-60c33',
    storageBucket: 'wastemanagement-60c33.firebasestorage.app',
    iosBundleId: 'com.example.wasteManagementSystemMobileapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAcwQAMJ1dx__4PLZfPVF3jT7XCJbFokWc',
    appId: '1:455331973314:ios:2b885e96b2de227462535b',
    messagingSenderId: '455331973314',
    projectId: 'wastemanagement-60c33',
    storageBucket: 'wastemanagement-60c33.firebasestorage.app',
    iosBundleId: 'com.example.wasteManagementSystemMobileapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD9CApePbzdHg6jFqMaKBOCVB7C7G8efgE',
    appId: '1:455331973314:web:23ca836f457825f262535b',
    messagingSenderId: '455331973314',
    projectId: 'wastemanagement-60c33',
    authDomain: 'wastemanagement-60c33.firebaseapp.com',
    storageBucket: 'wastemanagement-60c33.firebasestorage.app',
  );
}
