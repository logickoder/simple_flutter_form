import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/domain/service/auth_service.dart';
import 'app/route.dart';
import 'app/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute:
          // AuthService.noUserPresent() ? AppRoute.auth : AppRoute.forms,
          AppRoute.auth,
      routes: AppRoute.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
