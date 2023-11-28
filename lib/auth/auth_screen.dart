import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/asset.dart';
import '../app/domain/service/auth_service.dart';
import '../app/route.dart';
import '../app/theme.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = AppColor.of(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        decoration: BoxDecoration(
          color: color.card,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: .9,
              child: AspectRatio(
                aspectRatio: 1,
                child: SvgPicture.asset(
                  AppAsset.authStarIcon,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Explore the app',
              style: text.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color.title,
              ),
            ),
            Text(
              'Your forms all in one place',
              style: text.bodyLarge,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _handleAuthentication(
                  context,
                  _AuthType.google,
                ),
                icon: SvgPicture.asset(AppAsset.googleIcon),
                label: const Text('Continue with Google'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _handleAuthentication(
                  context,
                  _AuthType.facebook,
                ),
                icon: SvgPicture.asset(AppAsset.facebookIcon),
                label: const Text('Continue with Facebook'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _handleAuthentication(BuildContext context, _AuthType type) {
    final action = switch (type) {
      _AuthType.google => AuthService.signInWithGoogle(),
      _AuthType.facebook => AuthService.signInWithFacebook(),
    };
    action.then((_) {
      Navigator.pushReplacementNamed(context, AppRoute.forms);
    }).catchError((error) {
      String message;
      try {
        message = error.message;
      } catch (_) {
        message = error.toString();
      }

      showAdaptiveDialog(
        context: context,
        builder: (ctx) => AlertDialog.adaptive(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}

enum _AuthType {
  google,
  facebook,
}
