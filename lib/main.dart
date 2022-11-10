import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/string_constant.dart';
import 'package:note_app/screens/home.screen.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    ScreenUtilInit(
      builder: ((context, child) => MaterialApp(
            title: AppString.instance.nameApp,
            theme: ThemeData(
              fontFamily: 'Lato',
            ),
            routes: Routes.routes,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          )),
      designSize: const Size(428, 926),
    ),
  );
}
