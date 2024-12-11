import 'package:belajar_flutter/ui/add_recipe_screen.dart';
import 'package:belajar_flutter/ui/home_screen.dart';
import 'package:belajar_flutter/ui/login_screen.dart';
import 'package:belajar_flutter/ui/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-recipe': (context) => const AddRecipeScreen(),
      },
    );
  }
}
