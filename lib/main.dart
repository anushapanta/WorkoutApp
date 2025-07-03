//assignment 4
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'database/app_database.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final database = await $FloorAppDatabase.databaseBuilder('workout_database.db').build();
  runApp(MyApp(database: database));
  await  _signInAnonymously();
}

Future<void>  _signInAnonymously() async{
  try{
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in anonymously!");
    } else {
      print("User already signed in: ${FirebaseAuth.instance.currentUser!.uid}");
    }
  } catch (e) {
    print("Anonymous sign-in failed: $e");
  }
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(database: database),
    );
  }
}
