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
    apiKey: 'AIzaSyBND6Myz68Bwh1ryfkmsQKUniHWrJ6t2QQ',
    appId: '1:792874032621:web:a5dd709d7a38bbe2a89be4',
    messagingSenderId: '792874032621',
    projectId: 'ninja-brew-crew-9f20e',
    authDomain: 'ninja-brew-crew-9f20e.firebaseapp.com',
    storageBucket: 'ninja-brew-crew-9f20e.appspot.com',
    measurementId: 'G-CTN7PZ4NCQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAd152mnqrHvyR1OfCmJ-Yc9vtJVI4NnBQ',
    appId: '1:792874032621:android:969b385cbcfc206ea89be4',
    messagingSenderId: '792874032621',
    projectId: 'ninja-brew-crew-9f20e',
    storageBucket: 'ninja-brew-crew-9f20e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBj_zHQNACU0_9i3V0shGbWhAzlpFKGV6I',
    appId: '1:792874032621:ios:a62662d1bcd5cf7da89be4',
    messagingSenderId: '792874032621',
    projectId: 'ninja-brew-crew-9f20e',
    storageBucket: 'ninja-brew-crew-9f20e.appspot.com',
    iosClientId: '792874032621-7su9jie2ceiqf96pru7ejnedhtcqkfkt.apps.googleusercontent.com',
    iosBundleId: 'com.example.paspswordManagerFlutter2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBj_zHQNACU0_9i3V0shGbWhAzlpFKGV6I',
    appId: '1:792874032621:ios:8c7e6c941cea46cda89be4',
    messagingSenderId: '792874032621',
    projectId: 'ninja-brew-crew-9f20e',
    storageBucket: 'ninja-brew-crew-9f20e.appspot.com',
    iosClientId: '792874032621-nc13492qsl52ia47mthpqq9kfe27dljn.apps.googleusercontent.com',
    iosBundleId: 'com.example.paspswordManagerFlutter2.RunnerTests',
  );
}
