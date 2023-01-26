import 'package:firebase_abcd/views/splashView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'google_ml_kit_code.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        primarySwatch: Colors.deepPurple,
      ),
      home: const MLKit(),
    );
  }
}

