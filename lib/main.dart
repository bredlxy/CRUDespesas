import 'package:flutter/material.dart';
import 'views/login.dart';
import 'views/home.dart';
import 'views/adicionar.dart';
import 'views/relatorio.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAYaSMwWAYBd7Dnh5Y3oR58XaNuFf3pBzI",
      authDomain: "crudespesas.firebaseapp.com",
      projectId: "crudespesas",
      storageBucket: "crudespesas.firebasestorage.app",
      messagingSenderId: "779352946657",
      appId: "1:779352946657:web:f73265b01538a8c07304a0",
      measurementId: "G-TBQ6RJ5F3Q"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Satoshi',
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          titleMedium: TextStyle(fontSize: 18),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/adicionar': (context) => const Adicionar(),
        '/relatorio': (context) => const Relatorio(),
      },
    );
  }
}
