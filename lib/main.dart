import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:parkzo/auth/loginScreen.dart';
import 'package:parkzo/auth/otpScreen.dart'; // Import the LoginPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Lock the orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Lock the orientation to portrait mode
    DeviceOrientation.portraitDown, // Allow upside-down portrait if needed
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parkzo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Set LoginPage as the home screen
    );
  }
}