import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final String text = 'BDV: ';
  final String title = 'Precio BDV/Binance';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: text,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090b),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFfafafa),
          surface: Color(0xFF09090b),
          secondary: Color(0xFF27272a),
          onSurface: Color(0xFFfafafa),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: title),
    );
  }
}
