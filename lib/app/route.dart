import 'package:flutter/widgets.dart';

import '../auth/auth_screen.dart';
import '../form/form_screen.dart';
import '../form_list/form_list_screen.dart';

class AppRoute {
  static const auth = '/';
  static const forms = '/forms';
  static const form = '/forms/edit';

  static Map<String, WidgetBuilder> get routes => {
        auth: (_) => const AuthScreen(),
        form: (_) => const FormScreen(),
        forms: (_) => const FormListScreen(),
      };
}
