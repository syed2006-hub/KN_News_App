import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knownow/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  GoogleFonts.config.allowRuntimeFetching = false; // ✅ Prevents caching error
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: WidgetStateProperty.all(Colors.red)),
        ),
      ),
      home: const NewsPage(),
    );
  }
}
