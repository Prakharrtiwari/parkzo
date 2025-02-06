import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:parkzo/auth/loginScreen.dart';

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
      title: 'Firebase Initialization Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Initialization Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the new HomePage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text("Go to Home Page"),
        ),
      ),
    );
  }
}
