import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/screens/user_info/buttons.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/avatar/avatar_appbar.dart';
import 'package:provider/provider.dart';

import '../providers/auth.provider.dart';

class InfoUserScreen extends StatelessWidget {
  const InfoUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: CustomAppbar(
        title: "User info",
        handleBackBtn: (() => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Center(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AvatarAppbarWidget(
                      urlPhoto: userProvider.getCurrentUser.photoUrl!,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Change your Avatar here",
                            style: AppTextStyles.h6[TextWeights.extrabold]
                                ?.copyWith(color: AppColors.gray[60]),
                          ),
                          Text(
                            "Upload your favorite picture here (under 2MB)",
                            style: AppTextStyles.caption[TextWeights.regular]
                                ?.copyWith(color: AppColors.gray[50]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SmallIconButton(
                                onPressed: () {},
                                btnText: "Upload",
                                svgIcon: SvgPicture.asset(AssetPaths.upload),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Delete current avatar",
                                  style: AppTextStyles
                                      .caption[TextWeights.regular]
                                      ?.copyWith(
                                    color: const Color(0xffF44B3D),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Text(userProvider.getCurrentUser.displayName!,
                  style: AppTextStyles.h4[TextWeights.semibold]),
              Text(userProvider.getCurrentUser.email!,
                  style: AppTextStyles.h6[TextWeights.semibold]),
              Text(userProvider.getCurrentUser.uID!,
                  style: AppTextStyles.h6[TextWeights.semibold]),
              SizedBox(
                height: 100.h,
              ),
              ColorButton(
                text: 'Change my password',
                color: const Color(0xff8278F8),
                isOpacity: false,
                onpressed: () {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ColorButton(
                    text: "Delete my Account",
                    color: const Color(0xffF44B3D),
                    isOpacity: true,
                    isLarge: false,
                    onpressed: () {
                      debugPrint("Pressed");
                    },
                  ),
                  ColorButton(
                    text: "Save",
                    color: const Color(0xff0AC174),
                    isOpacity: true,
                    isLarge: false,
                    onpressed: () {
                      debugPrint("Pressed");
                    },
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
