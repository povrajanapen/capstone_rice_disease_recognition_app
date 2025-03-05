import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///
/// Definition of App Colors for RiceTheme.
///
class RiceColors {
  static Color primary            = const Color(0xFF34A853);

  static Color backgroundAccent   = const Color(0xFFEBECE1);

  static Color neutralDark        = const Color(0xFF293A25);
  static Color neutral            = const Color(0xFF5B7A54);
  static Color neutralLight       = const Color(0xFFD4DCB7);
  static Color neutralLighter     = const Color(0xFFEEF4DB);

  static Color greyLight          = const Color(0xFFE2E2E2);

  static Color red              = const Color(0xFFEB463D);
  static Color white              = Colors.white;

  static Color get backGroundColor { 
    return RiceColors.primary;
  }

  static Color get textNormal {
    return RiceColors.neutralDark;
  }

  static Color get textLight {
    return RiceColors.neutralLight;
  }

  static Color get iconNormal {
    return RiceColors.neutral;
  }

  static Color get iconLight {
    return RiceColors.neutralLighter;
  }

  static Color get disabled {
    return RiceColors.greyLight;
  }
}

///
/// Definition of Text Styles for RiceTheme.
///
class RiceTextStyles {
  static TextStyle heading = GoogleFonts.dmSans(fontSize: 35, fontWeight: FontWeight.w800);

  static TextStyle body = GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle label = GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle button = GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600);
}

///
/// Definition of Spacings for RiceTheme.
///
class RiceSpacings {
  static const double s = 12;
  static const double m = 20; 
  static const double l = 24; 
  static const double xl = 32; 
  static const double xxl = 40; 

  static const double radius = 10; 
  static const double radiusLarge = 15; 
}

///
/// Definition of App Theme for RiceTheme.
///
ThemeData riceTheme = ThemeData(
  fontFamily: 'DM Sans',
  scaffoldBackgroundColor: RiceColors.backgroundAccent,
);
