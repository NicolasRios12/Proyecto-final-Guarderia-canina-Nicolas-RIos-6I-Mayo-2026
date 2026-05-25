import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opciones de Firebase para el proyecto dogclubdata-base.
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no configurado para ${defaultTargetPlatform.name}',
        );
    }
  }

  /// Configuración web.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBxLHAG2CObJfU1UEvhPzBT2d1dBCmnRl0',
    appId: '1:417632057422:web:2e640f09fc4d65a387eb1f',
    messagingSenderId: '417632057422',
    projectId: 'dogclubdata-base',
    authDomain: 'dogclubdata-base.firebaseapp.com',
    storageBucket: 'dogclubdata-base.firebasestorage.app',
  );

  /// Configuración Android.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxLHAG2CObJfU1UEvhPzBT2d1dBCmnRl0',
    appId: '1:417632057422:android:c74a12ff033f9ee087eb1f',
    messagingSenderId: '417632057422',
    projectId: 'dogclubdata-base',
    storageBucket: 'dogclubdata-base.firebasestorage.app',
  );

  /// Configuración iOS.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxLHAG2CObJfU1UEvhPzBT2d1dBCmnRl0',
    appId: '1:417632057422:ios:0d6c2927c969155d87eb1f',
    messagingSenderId: '417632057422',
    projectId: 'dogclubdata-base',
    storageBucket: 'dogclubdata-base.firebasestorage.app',
    iosBundleId: 'com.example.proyectofinal',
  );

  /// Configuración macOS.
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxLHAG2CObJfU1UEvhPzBT2d1dBCmnRl0',
    appId: '1:417632057422:ios:0d6c2927c969155d87eb1f',
    messagingSenderId: '417632057422',
    projectId: 'dogclubdata-base',
    storageBucket: 'dogclubdata-base.firebasestorage.app',
    iosBundleId: 'com.example.proyectofinal',
  );

  /// Configuración Windows.
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBxLHAG2CObJfU1UEvhPzBT2d1dBCmnRl0',
    appId: '1:417632057422:web:534dac284904623787eb1f',
    messagingSenderId: '417632057422',
    projectId: 'dogclubdata-base',
    storageBucket: 'dogclubdata-base.firebasestorage.app',
  );
}
