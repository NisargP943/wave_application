import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave_app/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLarge18 => theme.textTheme.bodyLarge!.copyWith(
        color: Colors.white,
        fontSize: 16,
      );

  static get bodyLargeBlack900 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
      );

  static get bodyLargeBlack90018 => theme.textTheme.bodyLarge!
      .copyWith(color: appTheme.black900, fontSize: 28.spMin);

  static get bodyLargeBlack900_1 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
      );

  static get bodyLargeGray500 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray500,
      );

  static get bodyLargeInterBlack900 =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: appTheme.black900,
        fontSize: 17,
      );

  static get bodyLargeRed700 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.red700,
      );

  static get bodyLargeff000000 => theme.textTheme.bodyLarge!.copyWith(
        color: const Color(0XFF000000),
        fontSize: 18,
      );

  static get bodyLargeff222222 => theme.textTheme.bodyLarge!.copyWith(
        color: const Color(0XFF222222),
        fontSize: 18,
      );

  static get bodyMedium13 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 13,
        color: Colors.white,
      );

  static get bodyMediumGrey13 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 13.spMin,
        color: Colors.grey.withOpacity(0.8),
      );

  static get bodyMediumGrey13LineThrough =>
      theme.textTheme.bodyMedium!.copyWith(
        fontSize: 13.spMin,
        color: Colors.grey.withOpacity(0.8),
        decoration: TextDecoration.lineThrough,
      );

  static get bodySmallGrey11 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 11.spMin,
        color: Colors.grey.withOpacity(0.8),
      );

  static get bodyMediumBlack900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 22.spMin,
      );

  static get bodyMediumGray500 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray500,
      );

  static get bodyMediumGray50013 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray500,
        fontSize: 13,
      );

  static get bodyMediumGray500_1 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray500,
      );

  static get bodyMediumGray900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray900.withOpacity(0.64),
      );

  static get bodyMediumGreen600 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.green600,
      );

  static get bodyMediumOnPrimary => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );

  static get bodyMediumOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );

  static get bodyMediumRed700 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0xffA41C8E),
        fontSize: 16.spMin,
      );

  static get bodyMedium_1 => theme.textTheme.bodyMedium!;

  static get bodySmall11 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 12.spMin,
        color: Colors.white,
      );

  static get bodySmall11_1 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 12.spMin,
        color: Colors.grey.withOpacity(0.5),
      );

  static get bodySmallErrorContainer => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.errorContainer,
        fontSize: 11,
      );

  static get bodySmallGray900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray900,
        fontSize: 11,
      );

  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 11,
      );

  static get bodySmallRed700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.red700,
      );

  static get bodySmallff222222 => theme.textTheme.bodySmall!.copyWith(
        color: const Color(0XFF222222),
        fontSize: 11,
      );

  static get bodySmallff22222211 => theme.textTheme.bodySmall!.copyWith(
        color: const Color(0XFF222222),
        fontSize: 11,
      );

  static get bodySmallff9b9b9b => theme.textTheme.bodySmall!.copyWith(
        color: const Color(0XFF9B9B9B),
        fontSize: 11,
      );

  static get bodySmallff9b9b9b11 => theme.textTheme.bodySmall!.copyWith(
        color: Colors.black,
        fontSize: 11.spMin,
      );

  // Display text style
  static get displaySmallBlack900 => theme.textTheme.displaySmall!.copyWith(
        color: appTheme.black900,
      );

  static get displaySmallOnPrimary => theme.textTheme.displaySmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );

  // Headline text style
  static get headlineLargeAcmeGray900 =>
      theme.textTheme.headlineLarge!.acme.copyWith(
        color: appTheme.gray900,
      );

  static get headlineLargeOnPrimary => theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );

  static get headlineSmallAcmeGray900 =>
      theme.textTheme.headlineSmall!.acme.copyWith(
        color: appTheme.gray900,
        fontSize: 24,
        fontWeight: FontWeight.w400,
      );

  static get headlineSmallAcmeOnPrimary =>
      theme.textTheme.headlineSmall!.acme.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 24,
        fontWeight: FontWeight.w400,
      );

  // Title text style
  static get titleLargeAcmeBluegray100 =>
      theme.textTheme.titleLarge!.acme.copyWith(
        color: appTheme.blueGray100,
        fontSize: 21,
        fontWeight: FontWeight.w400,
      );

  static get titleLargeBlack900 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.black900,
        fontSize: 22,
      );

  static get titleLargeSemiBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w600,
      );

  static get titleMediumGray700 => theme.textTheme.titleMedium!.copyWith(
        color: Colors.black,
        fontSize: 19.spMin,
        fontWeight: FontWeight.w500,
      );

  static get titleMediumff407bff => theme.textTheme.titleMedium!.copyWith(
        color: const Color(0XFF407BFF),
      );
}

extension on TextStyle {
  TextStyle get anton {
    return copyWith(
      fontFamily: 'Anton',
    );
  }

  TextStyle get acme {
    return copyWith(
      fontFamily: 'Acme',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }
}
