import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final bool isBackBtn;
  final bool isRightBtn;
  final bool isTitle;
  final bool isBorderBottom;
  final List<Widget>? extraActions;
  final VoidCallback handleBackBtn;

  const CustomAppbar({
    super.key,
    this.isBackBtn = true,
    this.isRightBtn = true,
    this.isTitle = true,
    this.isBorderBottom = true,
    this.title = "",
    this.backgroundColor = AppColors.background,
    this.extraActions,
    required this.handleBackBtn,
  });

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: isBackBtn,
      elevation: 0.5,
      titleSpacing: 0,
      leadingWidth: 92.w,
      bottom: isBorderBottom
          ? PreferredSize(
              preferredSize: Size.fromHeight(0.2.w),
              child: Container(
                color: Colors.black,
                height: 0.2.w,
              ),
            )
          : null,
      leading: isBackBtn
          ? InkWell(
              onTap: handleBackBtn,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, right: 0),
                child: Row(children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 28.w,
                    color: AppColors.primary,
                  ),
                  Text(
                    "Back",
                    style: AppTextStyles.h6[TextWeights.semibold]?.copyWith(
                      color: AppColors.primary,
                    ),
                  )
                ]),
              ),
            )
          : null,
      title: isTitle
          ? Padding(
              padding: isBackBtn ? EdgeInsets.zero : EdgeInsets.all(16.w),
              child: Text(
                title,
                style: AppTextStyles.h4[TextWeights.semibold]?.copyWith(
                  color: AppColors.gray[70],
                ),
              ),
            )
          : null,
      actions: isRightBtn ? (extraActions) : null,
    );
  }
}
