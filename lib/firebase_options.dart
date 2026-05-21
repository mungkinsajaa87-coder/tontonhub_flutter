// File template agar project tetap lengkap saat pertama kali diextract.
// Setelah membuat project Firebase, jalankan:
// flutterfire configure
// Perintah tersebut akan meidPenggunapa file ini dengan konfigurasi Firebase asli.

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
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCMmrK8XviU8MVv14dwNRz8H58GzSCstBs',
    appId: '1:525968280847:web:7a7b4a5ee68f462caa827a',
    messagingSenderId: '525968280847',
    projectId: 'tontonhub-demo',
    authDomain: 'tontonhub-demo.firebaseapp.com',
    storageBucket: 'tontonhub-demo.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbzhaUasyUK6GI2QyDWeLRYuPzLPGBnxc',
    appId: '1:525968280847:android:87b4d8941e0bc0eeaa827a',
    messagingSenderId: '525968280847',
    projectId: 'tontonhub-demo',
    storageBucket: 'tontonhub-demo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAq3sg59xbZlfuOoD04_uNdwzx8GHQIwHQ',
    appId: '1:525968280847:ios:c54e0831e21adc84aa827a',
    messagingSenderId: '525968280847',
    projectId: 'tontonhub-demo',
    storageBucket: 'tontonhub-demo.firebasestorage.app',
    iosBundleId: 'com.exam',
  );

  static const FirebaseOptions macos = ios;

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCMmrK8XviU8MVv14dwNRz8H58GzSCstBs',
    appId: '1:525968280847:web:407b3df9f1057c6faa827a',
    messagingSenderId: '525968280847',
    projectId: 'tontonhub-demo',
    authDomain: 'tontonhub-demo.firebaseapp.com',
    storageBucket: 'tontonhub-demo.firebasestorage.app',
  );

}