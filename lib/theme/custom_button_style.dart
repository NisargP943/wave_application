import 'package:flutter/material.dart';
import 'package:wave_app/theme/theme_helper.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Outline button style
  static ButtonStyle get outlinePrimaryTL18 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.purple600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadowColor: theme.colorScheme.primary,
        elevation: 4,
      );

  static ButtonStyle get outlinePrimaryTL181 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.red700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadowColor: theme.colorScheme.primary,
        elevation: 4,
      );

  static ButtonStyle get outlinePrimaryTL24 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.red700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        shadowColor: theme.colorScheme.primary,
        elevation: 4,
      );

  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
      );
}
