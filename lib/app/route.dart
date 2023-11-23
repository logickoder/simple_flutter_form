import 'package:flutter/widgets.dart';

import '../auth/auth_screen.dart';

class AppRoute {
  static const auth = '/';

  static Map<String, WidgetBuilder> routes = {
    auth: (_) => const AuthScreen(),
  };
}
