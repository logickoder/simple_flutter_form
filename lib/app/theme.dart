import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final light = _get(
    color: const AppColor(
      primary: Color(0xFF000000),
      background: Color(0xFFFFFFFF),
      card: Color(0xFFF0F3FB),
      title: Color(0xFF000000),
      body: Color(0xB2000000),
      border: Color(0xFFD8DADC),
    ),
    base: ThemeData.light(),
  );

  static final dark = _get(
    color: const AppColor(
      primary: Color(0xFFFFFFFF),
      background: Color(0xFF000000),
      card: Color(0xFFF0F3FB),
      title: Color(0xFFFFFFFF),
      body: Color(0xB2FFFFFF),
      border: Color(0xFFD8DADC),
    ),
    base: ThemeData.dark(),
  );

  static ThemeData _get({required AppColor color, required ThemeData base}) {
    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: color.body,
        displayColor: color.body,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: color.primary,
        secondary: color.primary,
        background: color.background,
        surface: color.card,
        onSurface: color.body,
        onBackground: color.body,
      ),
      extensions: [
        color,
      ],
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: color.title,
          backgroundColor: color.background,
          side: BorderSide(color: color.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: color.background,
          backgroundColor: color.primary,
        ),
      ),
      inputDecorationTheme: () {
        final radius = BorderRadius.circular(10);
        return InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: color.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: color.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide(color: color.primary),
          ),
          contentPadding: const EdgeInsets.all(16),
          isDense: true,
          hintStyle: TextStyle(color: color.title.withOpacity(.5)),
        );
      }(),
    );
  }
}

class AppColor extends ThemeExtension<AppColor> {
  const AppColor({
    required this.primary,
    required this.background,
    required this.card,
    required this.title,
    required this.body,
    required this.border,
  });

  final Color primary;
  final Color background;
  final Color card;
  final Color title;
  final Color body;
  final Color border;

  static AppColor of(BuildContext context) {
    return Theme.of(context).extension<AppColor>()!;
  }

  @override
  ThemeExtension<AppColor> copyWith({
    Color? primary,
    Color? background,
    Color? card,
    Color? title,
    Color? body,
    Color? border,
  }) {
    return AppColor(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      card: card ?? this.card,
      title: title ?? this.title,
      body: body ?? this.body,
      border: border ?? this.border,
    );
  }

  @override
  ThemeExtension<AppColor> lerp(
    covariant ThemeExtension<AppColor>? other,
    double t,
  ) {
    if (other is! AppColor) {
      return this;
    }

    return AppColor(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      title: Color.lerp(title, other.title, t)!,
      body: Color.lerp(body, other.body, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}
