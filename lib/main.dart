import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess.com Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: AppColors.primaryGreen,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryGreen,
          surface: AppColors.surfaceDark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}