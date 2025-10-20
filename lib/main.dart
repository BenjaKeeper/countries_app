import 'package:countries_app/config/router/app_router.dart';
import 'package:countries_app/config/theme/app_theme.dart';
import 'package:countries_app/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Initialize dependency injection
  configureDependencies();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Countries App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: goRouter,
    );
  }
}
