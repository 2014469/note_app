import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';

class AppTextStyles {
  AppTextStyles._();
  static Map<TextWeights, TextStyle> h1 = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 96.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 96.sp,
    ),
    TextWeights.semibold: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 96.sp,
    ),
    TextWeights.extrabold: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 96.sp,
    )
  };

  static Map<TextWeights, TextStyle> h2 = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 60.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 60.sp,
    ),
    TextWeights.semibold: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 60.sp,
    ),
    TextWeights.extrabold: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 60.sp,
    )
  };
  static Map<TextWeights, TextStyle> h3 = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 48.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 48.sp,
    ),
    TextWeights.semibold: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 48.sp,
    ),
    TextWeights.extrabold: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 48.sp,
    )
  };
  static Map<TextWeights, TextStyle> h4 = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 34.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 34.sp,
    ),
    TextWeights.semibold: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 34.sp,
    ),
    TextWeights.extrabold: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 34.sp,
    )
  };
  static Map<TextWeights, TextStyle> h5 = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 26.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 26.sp,
    ),
    TextWeights.semibold: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 26.sp,
    ),
    TextWeights.extrabold: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 26.sp,
    )
  };

  static Map<TextWeights, TextStyle> h6 = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 20.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20.sp,
    ),
    TextWeights.semibold: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20.sp,
    ),
    TextWeights.extrabold: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 20.sp,
    )
  };

  static Map<TextWeights, TextStyle> body1 = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
    ),
    TextWeights.bold: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
    ),
  };
  static Map<TextWeights, TextStyle> body2 = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
    ),
    TextWeights.bold: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
    ),
  };
  static Map<TextWeights, TextStyle> caption = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
    ),
    TextWeights.bold: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 12.sp,
    ),
  };
  static Map<TextWeights, TextStyle> subtitile = <TextWeights, TextStyle>{
    TextWeights.regular: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.sp,
    ),
    TextWeights.medium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
    ),
    TextWeights.semibold: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
    ),
    TextWeights.extrabold: TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 16.sp,
    )
  };
}
