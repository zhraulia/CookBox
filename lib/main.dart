import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/login_provider.dart';
import 'screens/login_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CookBox',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppColors.background,
          textTheme: AppTextStyles.textTheme,
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
