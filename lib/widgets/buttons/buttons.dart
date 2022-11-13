import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

import '../../resources/fonts/enum_text_styles.dart';

// ignore: todo
// TODO: Thực hiện Cho phép custom màu button

// LargeButton: Là Button lớn, bao gồm các thuộc tính:
//      |__ onPressed: Bắt buộc, hàm xử lý cho sự kiện Press
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
    return isOutlined
        ? Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.r),
                      ),
                    ),
                    side: const BorderSide(width: 1, color: AppColors.primary)),
                child: iconPath == ""
                    ? Text(
                        text,
                        style: AppTextStyles.h5[TextWeights.semibold]?.copyWith(
                          color: AppColors.gray[80],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            iconPath,
                            width: 48.w,
                            height: 48.w,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Text(
                            text,
                            style: AppTextStyles.h5[TextWeights.semibold]
                                ?.copyWith(
                              color: AppColors.gray[80],
                            ),
                          ),
                        ],
                      )),
          )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                    ),
                    minimumSize: const Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.r)))),
                child: iconPath == ""
                    ? Text(
                        text,
                        style: AppTextStyles.h5[TextWeights.semibold]?.copyWith(
                          color: AppColors.gray[0],
                        ),
                      )
                    : Wrap(
                        children: [
                          Image.asset(
                            iconPath,
                            width: 48.w,
                            height: 48.h,
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Text(
                            text,
                            style: AppTextStyles.h5[TextWeights.semibold]
                                ?.copyWith(
                              color: AppColors.gray[0],
                            ),
                          ),
                        ],
                      )),
          );
  }
}

// Chưa xong âu :v, cần truyền tham số
class SmallButton extends StatelessWidget {
  final bool isOutlined;
  final Function()? onPressed;
  final String textBtn;
  const SmallButton({
    super.key,
    required this.isOutlined,
    this.onPressed,
    required this.textBtn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
//        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1, color: AppColors.primary),
                  minimumSize: Size(190.w, 60.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.r)))),
              child: Text(
                textBtn,
                style: AppTextStyles.h5[TextWeights.semibold]
                    ?.copyWith(color: AppColors.gray[100]),
              ))
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(190.w, 60.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.r)))),
              child: Text(
                textBtn,
                style: AppTextStyles.h5[TextWeights.semibold]
                    ?.copyWith(color: AppColors.gray[0]),
              ),
            ),
    );
  }
}
