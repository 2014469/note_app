import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/screens/user_info/widgets/buttons.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:note_app/widgets/avatar/avatar_appbar.dart';
import 'package:note_app/widgets/text_field/text_field.dart';
import 'package:provider/provider.dart';

import '../../models/auth_user.dart';
import '../../providers/auth.provider.dart';
import '../../widgets/bar/app_bar.dart';

class InfoUserScreen extends StatefulWidget {
  const InfoUserScreen({super.key});

  @override
  State<InfoUserScreen> createState() => _InfoUserScreenState();
}

class _InfoUserScreenState extends State<InfoUserScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

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
    UserProvider userProviderValue = Provider.of<UserProvider>(context);

    AuthUser user = userProviderValue.getCurrentUser;

    setState(() {
      _usernameController.text = user.displayName ?? "";

      _emailController.text = userProviderValue.getCurrentUser.email ?? "";
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        title: "User info",
        handleBackBtn: (() => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AvatarAppbarWidget(
                            urlPhoto:
                                userProviderValue.getCurrentUser.photoUrl!,
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
                                  style: AppTextStyles
                                      .caption[TextWeights.regular]
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
                                      svgIcon:
                                          SvgPicture.asset(AssetPaths.upload),
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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      child: Text(
                        "User name",
                        style: AppTextStyles.h5[TextWeights.semibold]
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                    InputField(
                      controller: _usernameController,
                      hintText: userProviderValue.getCurrentUser.displayName!,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      child: Text(
                        "Email",
                        style: AppTextStyles.h5[TextWeights.semibold]
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                    InputField(
                      isEditing: false,
                      controller: _emailController,
                      hintText: userProviderValue.getCurrentUser.email!,
                      fillColor: AppColors.gray[10]!,
                    ),
                    FirebaseAuth.instance.currentUser!.providerData[0]
                                .providerId
                                .toString() ==
                            "password"
                        ? ColorButton(
                            text: 'Change my password',
                            color: const Color(0xff8278F8),
                            isOpacity: false,
                            onpressed: () => Navigator.of(context)
                                .pushNamed(Routes.changePassword),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ColorButton(
                          text: "Delete my Account",
                          color: const Color(0xffF44B3D),
                          isOpacity: true,
                          isLarge: false,
                          onpressed: () => Navigator.of(context)
                              .pushNamed(Routes.deleteAccount),
                        ),
                        ColorButton(
                          text: "Save",
                          color: const Color(0xff0AC174),
                          isOpacity: true,
                          isLarge: false,
                          onpressed: () {
                            user.displayName = _usernameController.text;
                            // user.photoUrl =

                            userProviderValue.updateUser(user: user);
                          },
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
