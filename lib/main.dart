import 'package:flutter/material.dart';
import 'package:note_app/resources/constants/string_constant.dart';
import 'package:note_app/screens/home.screen.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: const [],
      child: ScreenUtilInit(
        builder: ((context, child) => MaterialApp(
              title: AppString.instance.nameApp,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'Lato',
              ),
              routes: Routes.routes,
              home: const HomeScreen(),
            )),
        designSize: const Size(428, 926),
      ),
    ),
  );
}
