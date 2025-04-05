import 'package:chat_app/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
        apiKey: "AIzaSyANRU-GU1gsqTXwnmxF9_APiokUHa1BDpo",
        authDomain: "chat-app-82cb7.firebaseapp.com",
        projectId: "chat-app-82cb7",
        storageBucket: "chat-app-82cb7.firebasestorage.app",
        messagingSenderId: "96080305404",
        appId: "1:96080305404:web:caa47052392eee9215cb79",
        measurementId: "G-CHVFDB0ZRY"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
