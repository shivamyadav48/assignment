import 'package:assignment/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'UI/screen/home_screen.dart';

void main() {
  runApp(const FreightRateApp());
}

class FreightRateApp extends StatelessWidget {
  const FreightRateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Freight Rate Search',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}