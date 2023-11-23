import 'package:flutter/material.dart';

import 'app/route.dart';
import 'app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form',
      theme: AppTheme.light,
      // darkTheme: AppTheme.dark,
      routes: AppRoute.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
