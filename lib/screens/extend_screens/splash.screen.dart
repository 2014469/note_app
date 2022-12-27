import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/widgets/logo/images_logo.dart';

import '../../main.dart';
import '../../providers/auth.provider.dart';
import '../../providers/folder.provider.dart';

class OurSplashScreen extends StatefulWidget {
  const OurSplashScreen({super.key});

  @override
  State<OurSplashScreen> createState() => _OurSplashScreenState();
}

class _OurSplashScreenState extends State<OurSplashScreen> {
  late UserProvider userProvider;
  late FolderProvider folderProvider;

  @override
  void initState() {
    _navigatorHome(context);
    super.initState();
  }

  _navigatorHome(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 3000), () {
      goToAuthWrapper();
    });
  }

  void goToAuthWrapper() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthWrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: CustomAppbarLogin(handleBackBtn: () => Navigator.of(context).pop()),
        body: SafeArea(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // images logo
          const ImageLogo(),
          // text notification
          SizedBox(
            height: 64.h,
          ),
          Text(
            'Note App',
            textAlign: TextAlign.center,
            style: AppTextStyles.h3[TextWeights.semibold]
                ?.copyWith(color: AppColors.primary),
          ),
        ]),
      ),
    ));
  }
}
