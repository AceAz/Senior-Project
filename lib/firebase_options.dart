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
    apiKey: 'AIzaSyCRw90ir2-wsZluFuYwLVhUw2YPiIUG3dI',
    appId: '1:1029220083043:web:f899de3864a68402a2df56',
    messagingSenderId: '1029220083043',
    projectId: 'parkwise-4f027',
    authDomain: 'parkwise-4f027.firebaseapp.com',
    storageBucket: 'parkwise-4f027.firebasestorage.app',
    measurementId: 'G-YM6VLH9ZS2',
    databaseURL: 'https://parkwise-4f027-default-rtdb.firebaseio.com/',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVW2O84JBAfKjNX5XjIiBIyVrPAtXB6Rs',
    appId: '1:1029220083043:android:6a874643d6c78df0a2df56',
    messagingSenderId: '1029220083043',
    projectId: 'parkwise-4f027',
    storageBucket: 'parkwise-4f027.firebasestorage.app',
    databaseURL: 'https://parkwise-4f027-default-rtdb.firebaseio.com/',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXQ_Tq0Ba2MNeHBKeF-hSOEnjNw3dBSOM',
    appId: '1:1029220083043:ios:426541dd8d0c55d9a2df56',
    messagingSenderId: '1029220083043',
    projectId: 'parkwise-4f027',
    storageBucket: 'parkwise-4f027.firebasestorage.app',
    iosBundleId: 'com.example.parkWise',
    databaseURL: 'https://parkwise-4f027-default-rtdb.firebaseio.com/',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXQ_Tq0Ba2MNeHBKeF-hSOEnjNw3dBSOM',
    appId: '1:1029220083043:ios:426541dd8d0c55d9a2df56',
    messagingSenderId: '1029220083043',
    projectId: 'parkwise-4f027',
    storageBucket: 'parkwise-4f027.firebasestorage.app',
    iosBundleId: 'com.example.parkWise',
    databaseURL: 'https://parkwise-4f027-default-rtdb.firebaseio.com/',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCRw90ir2-wsZluFuYwLVhUw2YPiIUG3dI',
    appId: '1:1029220083043:web:df45d3877a0c9195a2df56',
    messagingSenderId: '1029220083043',
    projectId: 'parkwise-4f027',
    authDomain: 'parkwise-4f027.firebaseapp.com',
    storageBucket: 'parkwise-4f027.firebasestorage.app',
    measurementId: 'G-0N4E6TSRG0',
    databaseURL: 'https://parkwise-4f027-default-rtdb.firebaseio.com/',
  );
}
