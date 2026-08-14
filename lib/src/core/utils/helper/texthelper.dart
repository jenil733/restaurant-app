import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';

class TextHelper {
  static TextStyle get heading1 {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textprimary,
    );
  }

  static TextStyle get login {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.textprimary,
    );
  }

  static TextStyle get heading3 {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textprimary,
    );
  }

  static TextStyle get heading2 {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textprimary,
    );
  }

  static TextStyle get button {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textprimary,
    );
  }
  
  static TextStyle get locationheading {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.locationtext,
    );
  }
  
  static TextStyle get protext {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textprimary,
    );
  }

  static TextStyle get prosubtext {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textprimary,
    );
  }

  static TextStyle get provalue {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textprimary,
    );
  }

  static TextStyle get provalue1 {
    return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.textprimary,
    );
  }

  static TextStyle get discount {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: AppColors.green,
    );
  }
}
