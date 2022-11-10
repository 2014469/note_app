import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors/colors.dart';
import '../resources/fonts/enum_text_styles.dart';
import '../resources/fonts/text_styles.dart';

// LargeButton: Là Button lớn, bao gồm các thuộc tính:
//      |__ isOutlined: Bắt buộc, định nghĩa kiểu của Button
//      |       |__ True: OutLined (Có viền, không có background)
//      |       |__ False: Elevated (Không có viền, background màu primary)
//      |__ text: Không bắt buộc, định nghĩa tiêu đề của Button, mặc định là Large Button
//      |__ iconPath: Không bắt buộc, định nghĩa icon của button. Truyền ĐƯỜNG DẪN của icon, KHÔNG truyền Icon vào widget (Lấy đường dẫn từ class AssetPaths)

class LargeButton extends StatelessWidget {
  final bool isOutlined;
  final String text;
  final String iconPath;
  final Function()? onPressed;
  const LargeButton(
      {super.key,
      this.text = "Large Button",
      this.iconPath = "",
      required this.isOutlined,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(60.h),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32))),
                  side: const BorderSide(width: 1, color: AppColors.primary)),
              child: iconPath == ""
                  ? Text(
                      text,
                      style: AppTextStyles.h5[TextWeights.semibold]?.copyWith(
                        color: AppColors.gray[100],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(iconPath),
                        SizedBox(
                          width: 16.w,
                        ),
                        Text(
                          text,
                          style:
                              AppTextStyles.h5[TextWeights.semibold]?.copyWith(
                            color: AppColors.gray[100],
                          ),
                        ),
                      ],
                    ))
          : ElevatedButton(
             onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size.fromHeight(60.h),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),
              child: iconPath == ""
                  ? Text(
                      text,
                      style: AppTextStyles.h5[TextWeights.semibold]?.copyWith(
                        color: AppColors.gray[0],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(iconPath),
                        SizedBox(
                          width: 16.w,
                        ),
                        Text(
                          text,
                          style:
                              AppTextStyles.h5[TextWeights.semibold]?.copyWith(
                            color: AppColors.gray[0],
                          ),
                        ),
                      ],
                    )),
    );
  }
}

class SmallButton extends StatelessWidget {
  final bool isOutlined;
  final Function()? onPressed;
  const SmallButton({super.key, required this.isOutlined, this.onPressed});

  @override
  Widget build(BuildContext context) {
    double phoneWidth=MediaQuery.of(context).size.width;
    return Container(
        margin: EdgeInsets.all(16.w),
        child: isOutlined
            ? OutlinedButton(
                onPressed: onPressed, child: const Text("Small Button"))
            : ElevatedButton(
                onPressed: onPressed, child: const Text("Small Button")));
  }
}
