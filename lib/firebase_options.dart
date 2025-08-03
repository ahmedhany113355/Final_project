
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show
        defaultTargetPlatform,
        kIsWeb,
        TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

 static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCD8YuvCup2UYmkrKiBu36Z6hKhVOBX02I',
    appId: '1:96749583906:web:b2ff82192fbfc88033d47b',
    messagingSenderId: '96749583906',
    projectId: 'myecommerceapp-yourname',
    authDomain: 'myecommerceapp-yourname.firebaseapp.com', 
    storageBucket:
        'myecommerceapp-yourname.firebasestorage.app',
    measurementId: 'G-4P9BM3ZW7S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCD8YuvCup2UYmkrKiBu36Z6hKhVOBX02I',
    appId: '1:96749583906:web:b2ff82192fbfc88033d47b',
    messagingSenderId: '96749583906',
    projectId: 'myecommerceapp-yourname',
    storageBucket: 'myecommerceapp-yourname.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCD8YuvCup2UYmkrKiBu36Z6hKhVOBX02I',
    appId: '1:96749583906:web:b2ff82192fbfc88033d47b',
    messagingSenderId: '96749583906',
    projectId: 'myecommerceapp-yourname',
    storageBucket: 'myecommerceapp-yourname.firebasestorage.app',
    iosClientId: '',
    iosBundleId: '',
  );

 static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCD8YuvCup2UYmkrKiBu36Z6hKhVOBX02I',
    appId: '1:96749583906:web:b2ff82192fbfc88033d47b',
    messagingSenderId: '96749583906',
    projectId: 'myecommerceapp-yourname',
    storageBucket: 'myecommerceapp-yourname.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCD8YuvCup2UYmkrKiBu36Z6hKhVOBX02I',
    appId: '1:96749583906:web:b2ff82192fbfc88033d47b',
    messagingSenderId: '96749583906',
    projectId: 'myecommerceapp-yourname',
    storageBucket: 'myecommerceapp-yourname.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyCD8YuvCup2UYmkrKiBu36Z6hKhVOBX02I',
    appId: '1:96749583906:web:b2ff82192fbfc88033d47b',
    messagingSenderId: '96749583906',
    projectId: 'myecommerceapp-yourname',
    storageBucket: 'myecommerceapp-yourname.firebasestorage.app',
  );
}
