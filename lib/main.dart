import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/string_constant.dart';
import 'package:note_app/screens/home.screen.dart';
import 'package:note_app/screens/login.screen.dart';
import 'package:note_app/screens/send_email.screen.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:note_app/services/auth/firebase_auth_provider.dart';
import 'package:note_app/utils/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // todo: intial firebase
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
      ],
      child: ScreenUtilInit(
        builder: ((context, child) => MaterialApp(
              title: AppString.instance.nameApp,
              theme: ThemeData(
                fontFamily: 'Lato',
              ),
              routes: Routes.routes,
              home: const AuthWrapper(),
              debugShowCheckedModeBanner: false,
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
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      if (firebaseUser.emailVerified) {
        return const HomeScreen();
      } else {
        return const SendEmail();
      }
    }
    return const LoginScreen();
  }
}
