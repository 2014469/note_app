import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  const SearchBar({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromRGBO(118, 118, 128, 0.12),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: "Search",
            hintStyle: AppTextStyles.body1[TextWeights.regular]
                ?.copyWith(color: AppColors.gray[50]),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  left: 8.18.w, top: 11.81.h, bottom: 11.81..h, right: 6.0.w),
              child: const Icon(Icons.search),
            ),
            suffixIcon: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 8.18.w, vertical: 11.81.h),
              child: InkWell(child: const Icon(Icons.mic), onTap: () {}),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
