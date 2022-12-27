import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/screens/user_info/widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../../../widgets/bar/app_bar.dart';
import '../../providers/auth.provider.dart';
import '../../resources/colors/colors.dart';
import '../../resources/fonts/enum_text_styles.dart';
import '../../resources/fonts/text_styles.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/routes/routes.dart';
import '../../utils/show_snack_bar.dart';
import 'checkbox.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _dontWant = false;
  bool _haveAnotherAccount = false;
  bool _haveProblem = false;
  final TextEditingController _addition = TextEditingController();
  late UserProvider userProvider;
  @override
  void initState() {
    userProvider = Provider.of(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppbar(
        title: 'Delete account',
        isH5Title: true,
        handleBackBtn: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32.h,
              ),
              Text(
                "Please tell us the reason",
                style: AppTextStyles.h5[TextWeights.semibold]
                    ?.copyWith(color: AppColors.primary),
              ),
              SizedBox(
                height: 32.h,
              ),

              //Check box list
              AppCheckBox(
                title: "I don't want to use UniNote",
                value: _dontWant,
                onChanged: (value) {
                  setState(() {
                    _dontWant = !_dontWant;
                  });
                },
              ),
              SizedBox(
                height: 16.h,
              ),
              AppCheckBox(
                title: "I have another account",
                value: _haveAnotherAccount,
                onChanged: (value) {
                  setState(() {
                    _haveAnotherAccount = !_haveAnotherAccount;
                  });
                },
              ),
              SizedBox(
                height: 16.h,
              ),
              AppCheckBox(
                title: "There are some problems with Uninote",
                value: _haveProblem,
                onChanged: (value) {
                  setState(() {
                    _haveProblem = !_haveProblem;
                  });
                },
              ),
              SizedBox(
                height: 52.h,
              ),
              Text(
                "Anything else you want to add?",
                style: AppTextStyles.h5[TextWeights.semibold]
                    ?.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 16.h),

              // Text Field Multi lines
              TextField(
                maxLines: 6,
                cursorColor: AppColors.gray[60],
                controller: _addition,
                style: AppTextStyles.body1[TextWeights.regular]
                    ?.copyWith(color: AppColors.gray[60]),
                decoration: InputDecoration(
                    hintText: 'Suggest something to help us improve UniNote',
                    hintStyle: AppTextStyles.body1[TextWeights.regular]
                        ?.copyWith(color: AppColors.gray[50]),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    fillColor: AppColors.gray[10],
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.r)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.r))),
              ),
              Text(
                "* All the data will be deleted permanetly from our server including your profile, infomation, notes, etc",
                style: AppTextStyles.caption[TextWeights.regular]?.copyWith(
                  color: AppColors.red,
                ),
              ),
              SizedBox(
                height: 132.h,
              ),
              ColorButton(
                  isRounded: false,
                  isOpacity: false,
                  text: "Delete my Account Now",
                  color: AppColors.red,
                  onpressed: () async {
                    userProvider.deleteUser(
                        uId: FirebaseAuth.instance.currentUser!.uid);
                    await context.read<AuthService>().deleteAccount();

                    Future.delayed(Duration.zero, () {
                      showSnackBarSuccess(context, "Deleted Successfully");
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.authWrapper);
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
