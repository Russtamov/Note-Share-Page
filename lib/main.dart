import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:note_share_project/login/login_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyDNoZrkykEYw-u8zEm3cvsRLGmrAGNX0BA",
            appId: "1:1046419929124:web:eaa2a444310f4ee9a100b1",
            messagingSenderId: "1046419929124",
            projectId: "note-share-81d69",
            storageBucket: "note-share-81d69.appspot.com",
          )
        : null,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Share',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
