import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.background,
    required this.card,
  });

  final Color primary;
  final Color background;
  final Color card;

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>()!;
  }

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primary,
    Color? background,
    Color? card,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      card: card ?? this.card,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
    );
  }
}

class AppTheme {
  static final light = ThemeData.light().copyWith(
    extensions: [
      _lightAppColors,
    ],
  );

  static const _lightAppColors = AppColors(
    primary: Color(0xFF000000),
    background: Color(0xFFFFFFFF),
    card: Color(0xFFF0F3FB),
  );

  static final dark = ThemeData.dark().copyWith(
    extensions: [
      _darkAppColors,
    ],
  );

  static const _darkAppColors = AppColors(
    primary: Color(0xFFFFFFFF),
    background: Color(0xFF000000),
    card: Color(0xFFF0F3FB),
  );
}
