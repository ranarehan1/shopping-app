import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list_app/screens/grocery_items_screen.dart';
import 'package:shopping_list_app/screens/teaching.dart';

ThemeData myTheme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(255, 204, 204, 255),
    // surface: const Color.fromRGBO(224, 224, 224, 255),
  ),
  textTheme: GoogleFonts.exo2TextTheme(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Groceries",
      theme: myTheme,
      themeMode: ThemeMode.light,
      home: const Teaching(),
    );
  }
}
