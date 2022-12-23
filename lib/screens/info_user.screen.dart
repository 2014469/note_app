import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/screens/user_info/buttons.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/avatar/avatar_appbar.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';
import '../providers/auth.provider.dart';

class InfoUserScreen extends StatelessWidget {
  const InfoUserScreen({super.key});

  _getFromGallery() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (file != null) {
      // File imageFile = File(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        title: "User info",
        handleBackBtn: (() => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Center(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                onPressed: () {
                                  _getFromGallery();
                                },
                                btnText: "Upload",
                                svgIcon: SvgPicture.asset(AssetPaths.upload),
                              ),
                              TextButton(
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: Text(
                  "User name",
                  style: AppTextStyles.h5[TextWeights.semibold]
                      ?.copyWith(color: AppColors.primary),
                ),
              ),
              InputField(
                controller: usernameController,
                hintText: userProvider.getCurrentUser.displayName!,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: Text(
                  "Email",
                  style: AppTextStyles.h5[TextWeights.semibold]
                      ?.copyWith(color: AppColors.primary),
                ),
              ),
              InputField(
                controller: emailController,
                hintText: userProvider.getCurrentUser.email!,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
                child: ColorButton(
                  text: 'Change my password',
                  color: const Color(0xff8278F8),
                  isOpacity: false,
                  onpressed: () =>
                      Navigator.of(context).pushNamed(Routes.changePassword),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColorButton(
                      text: "Delete my Account",
                      color: AppColors.red,
                      isOpacity: true,
                      isLarge: false,
                      onpressed: () =>
                          Navigator.of(context).pushNamed(Routes.deleteAccount),
                    ),
                    ColorButton(
                      text: "Save",
                      color: AppColors.green,
                      isOpacity: true,
                      isLarge: false,
                      onpressed: () {
                        debugPrint("Pressed");
                      },
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
