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
    apiKey: 'AIzaSyAOZn5IqjGL4tt8REPJzAFlzzNGHdL6KAw',
    appId: '1:26102194288:web:7e6b86ac5e2f8b4ab914b5',
    messagingSenderId: '26102194288',
    projectId: 'note-app-e936e',
    authDomain: 'note-app-e936e.firebaseapp.com',
    storageBucket: 'note-app-e936e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA41ZI6qLbvuGHvhzqhEYn_gpobQPl5oZQ',
    appId: '1:26102194288:android:4abdce48791ae3f0b914b5',
    messagingSenderId: '26102194288',
    projectId: 'note-app-e936e',
    storageBucket: 'note-app-e936e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAP0VELI9w5BTkm2m8aL4CrL4ADiRUceEY',
    appId: '1:26102194288:ios:eb22d2bea37fab3fb914b5',
    messagingSenderId: '26102194288',
    projectId: 'note-app-e936e',
    storageBucket: 'note-app-e936e.appspot.com',
    iosClientId: '26102194288-lboi8t1lol9jhuiuj0c49spadkf8u9um.apps.googleusercontent.com',
    iosBundleId: 'com.example.tranlong',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAP0VELI9w5BTkm2m8aL4CrL4ADiRUceEY',
    appId: '1:26102194288:ios:f467d7583aab3753b914b5',
    messagingSenderId: '26102194288',
    projectId: 'note-app-e936e',
    storageBucket: 'note-app-e936e.appspot.com',
    iosClientId: '26102194288-527k9fa51shalnlnq7fijhj8at7c4b31.apps.googleusercontent.com',
    iosBundleId: 'com.example.noteApp',
  );
}