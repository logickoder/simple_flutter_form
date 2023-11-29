import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/asset.dart';
import '../app/domain/service/auth_service.dart';
import '../app/domain/service/form_service.dart';
import '../app/route.dart';
import '../app/theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isGoogleSignInLoading = false;
  var _isFacebookSignInLoading = false;

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
                onPressed: _isGoogleSignInLoading
                    ? null
                    : () => _handleAuthentication(_AuthType.google),
                icon: SvgPicture.asset(AppAsset.googleIcon),
                label: _isGoogleSignInLoading
                    ? const CircularProgressIndicator()
                    : const Text('Continue with Google'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isFacebookSignInLoading
                    ? null
                    : () => _handleAuthentication(_AuthType.facebook),
                icon: SvgPicture.asset(AppAsset.facebookIcon),
                label: _isFacebookSignInLoading
                    ? const CircularProgressIndicator()
                    : const Text('Continue with Facebook'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _handleAuthentication(_AuthType type) {
    setState(() {
      switch (type) {
        case _AuthType.google:
          _isGoogleSignInLoading = true;
          break;
        case _AuthType.facebook:
          _isFacebookSignInLoading = true;
          break;
      }
    });
    final action = switch (type) {
      _AuthType.google => AuthService.signInWithGoogle(),
      _AuthType.facebook => AuthService.signInWithFacebook(),
    };
    action.then((_) {
      _loadFormsFromRemote();
    }).catchError(_handleError);
  }

  void _loadFormsFromRemote() async {
    FormService.getFromFirebase()
        .then((value) {
          Navigator.pushReplacementNamed(context, AppRoute.forms);
        })
        .catchError(_handleError)
        .whenComplete(_clearLoadingState);
  }

  FutureOr<Null> _handleError(dynamic error) {
    _clearLoadingState();

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
  }

  void _clearLoadingState() {
    setState(() {
      _isGoogleSignInLoading = false;
      _isFacebookSignInLoading = false;
    });
  }
}

enum _AuthType {
  google,
  facebook,
}
