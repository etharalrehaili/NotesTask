import 'package:flutter/material.dart';
import 'package:untitled5/screen/NotesScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Task: Notes App (Local DB)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      home: const MyHomePage(title: 'Flutter Notes App'),
    );
  }
}
