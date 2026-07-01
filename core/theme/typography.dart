import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTypography {
  static TextStyle get hankenGrotesk => GoogleFonts.hankenGrotesk();
  static TextStyle get inter => GoogleFonts.inter();

  static final TextStyle displayLarge = GoogleFonts.hankenGrotesk(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface);
  static final TextStyle displayMedium = GoogleFonts.hankenGrotesk(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface);
  static final TextStyle headlineMedium = GoogleFonts.hankenGrotesk(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onSurface);
  static final TextStyle bodyLarge = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onSurface);
  static final TextStyle bodyMedium = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.onSurface);
  static final TextStyle labelLarge = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface);
  static final TextStyle labelSmall = GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant);

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineMedium: headlineMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    labelLarge: labelLarge,
    labelSmall: labelSmall,
  );
}
