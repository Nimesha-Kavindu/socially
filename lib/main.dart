import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socially/firebase_options.dart';
import 'package:socially/router/router.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterClass().router,

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,

        brightness: Brightness.dark,

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: mainOrangeColor,
          unselectedItemColor: mainWhiteColor,
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: mainOrangeColor,

          contentTextStyle: TextStyle(
            color: mainWhiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
