import 'package:flutter/widgets.dart';

import '../auth/auth_screen.dart';
import '../form/form_screen.dart';

class AppRoute {
  static const auth = '/';
  static const form = '/form';

  static Map<String, WidgetBuilder> routes = {
    auth: (_) => const AuthScreen(),
    form: (_) => const FormScreen(),
  };
}
