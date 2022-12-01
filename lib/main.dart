import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/providers/folder.provider.dart';
import 'package:note_app/providers/note.provider.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/string_constant.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';
import 'package:note_app/screens/sign_in_up/login.screen.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/services/auth/firebase_auth_provider.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'providers/auth.provider.dart';
import 'screens/home.screen.dart';
import 'screens/sign_in_up/verify_email.screen.dart';

// import 'package:provider/provider.dart'
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  await AuthService.firebase().initialize();

// todo: change color status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

// todo: lock xoay man hinh
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuthProvider()),
        ),
        StreamProvider(
          create: ((context) => context.read<AuthService>().authState),
          initialData: null,
        ),
        ChangeNotifierProvider<FolderProvider>(
          create: (context) => FolderProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<NoteProvider>(
          create: (context) => NoteProvider(),
        ),
      ],
      child: ScreenUtilInit(
        builder: ((context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppString.instance.nameApp,
              theme: ThemeData(
                fontFamily: 'Lato',
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.r)),
                      borderSide:
                          BorderSide(color: AppColors.gray[30]!, width: 0.5)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.r),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.yellowGold,
                      width: 2.w,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: AppTextStyles.h5[TextWeights.regular]!.copyWith(
                    color: AppColors.gray[40],
                  ),
                ),
              ),
              routes: Routes.routes,
              home: const AuthWrapper(),
            )),
        designSize: const Size(428, 926),
      ),
    ),
  );
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(
      builder: (context, value, child) {
        if (value != null) {
          bool isCheck = context.read<AuthService>().authIsVerifiedEmail;
          if (isCheck) {
            // return const Text("Home screen");
            return const HomeScreen();
          } else {
            return const VerifyEmailScreen();
          }
        } else {
          return const LoginScreen();
        }
      },
    );
    // return const EditNoteScreen();

    // return HomePage();
  }
}
