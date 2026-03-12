import 'package:flutter/material.dart';
import 'package:my_dolar/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String appTitle = 'Precio BDV/Binance';
  static const Color scaffoldBg = Color(0xFF09090b);
  static const Color borderColor = Color(0xFF27272a);
  static const Color primaryWhite = Color(0xFFfafafa);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dolar App',

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: scaffoldBg,
        colorScheme: const ColorScheme.dark(
          primary: primaryWhite,
          surface: scaffoldBg,
          secondary: borderColor,
          onSurface: primaryWhite,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: scaffoldBg,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: primaryWhite, size: 20),
          shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
        ),

        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            color: primaryWhite,
          ),
        ),
      ),

      home: const MyHomePage(title: appTitle),
    );
  }
}
