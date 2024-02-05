import 'package:flutter/material.dart';
import 'package:wave_app/theme/theme_helper.dart';

class AppDecoration {
  // Background decorations
  static BoxDecoration get background => BoxDecoration(
        color: appTheme.gray5001,
      );

  // Fill decorations
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray50,
      );

  static BoxDecoration get fillGray900 => BoxDecoration(
        color: appTheme.gray900,
      );

  static BoxDecoration get fillPurple => BoxDecoration(
        color: appTheme.purple600,
      );

  static BoxDecoration get fillRed => BoxDecoration(
        color: appTheme.red700,
      );

  // Gradient decorations
  static BoxDecoration get gradientPurpleToPurple => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 1),
          colors: [
            appTheme.purple600,
            appTheme.purple600,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.12),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlack900 => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlack9001 => BoxDecoration(
        color: appTheme.gray5001,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(
              0,
              -4,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlack9002 => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.16),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlack9003 => BoxDecoration(
        color: appTheme.gray5001,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlack9004 => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineBlack9005 => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.12),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineErrorContainer => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border.all(
          color: theme.colorScheme.errorContainer,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );

  static BoxDecoration get outlineGray => BoxDecoration(
        border: Border.all(
          color: appTheme.gray900,
          width: 1,
        ),
      );

  // White decorations
  static BoxDecoration get white => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder12 => BorderRadius.circular(
        12,
      );

  static BorderRadius get circleBorder15 => BorderRadius.circular(
        15,
      );

  static BorderRadius get circleBorder18 => BorderRadius.circular(
        18,
      );

  static BorderRadius get circleBorder32 => BorderRadius.circular(
        32,
      );

  // Custom borders
  static BorderRadius get customBorderBL8 => const BorderRadius.vertical(
        bottom: Radius.circular(8),
      );

  static BorderRadius get customBorderLR35 => const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(35),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(35),
      );

  static BorderRadius get customBorderTL34 => const BorderRadius.vertical(
        top: Radius.circular(34),
      );

  static BorderRadius get customBorderTL8 => const BorderRadius.horizontal(
        left: Radius.circular(8),
      );

  // Rounded borders
  static BorderRadius get roundedBorder24 => BorderRadius.circular(
        24,
      );

  static BorderRadius get roundedBorder4 => BorderRadius.circular(
        4,
      );

  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
