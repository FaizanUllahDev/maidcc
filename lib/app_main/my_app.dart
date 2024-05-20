import 'package:maidcc/core/app_theme/app_theme.dart';
import 'package:maidcc/core/router/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Craft',
      routerConfig: AppRouter.router,
      theme: AppTheme.theme,
    );
  }
}
