import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import '../utils/customLog/debug_log.dart';
import '../widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser;
    // todo: setter display name
    // user.updateDisplayName("long");
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        handleBackBtn: (() {
          DebugLog.myLog("Backbtn");
        }),
        extraActions: const <Widget>[],
        title: "All Notes",
      ),
      body: SafeArea(
        child: Column(
          children: [
            // if (!user.isAnonymous) Text("Email: ${user.email!}"),
            // SizedBox(
            //   height: 16.h,
            // ),
            // if (!user.isAnonymous) Text("Username: ${user.displayName}"),
            // SizedBox(
            //   height: 16.h,
            // ),
            // if (!user.isAnonymous) Image.network(user.photoURL ?? ""),
            // SizedBox(
            //   height: 16.h,
            // ),
            // if (!user.isAnonymous)
            //   Text("Provider id: ${user.providerData[0].providerId}"),
            // SizedBox(
            //   height: 16.h,
            // ),
            // Text("UID: ${user.uid}"),
            // const Center(
            //   child: Text("Home screen! Logged in"),
            // ),
            // SizedBox(
            //   height: 16.h,
            // ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthService>().logOUt();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthService>().deleteAccount();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
              child: const Text(
                "Delete account",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}