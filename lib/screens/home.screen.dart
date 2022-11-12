import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/auth_user.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import '../utils/customLog/debug_log.dart';
import '../widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthUser user = AuthUser();
    return FutureBuilder<AuthUser?>(
      future: context.read<AuthService>().currentUser,
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (data != null) {
          user = data;
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
                  Text("Email: ${user.email}"),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text("Username: ${user.displayName}"),
                  SizedBox(
                    height: 16.h,
                  ),
                  Image.network(user.photoUrl!),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text("UID: ${user.uID}"),
                  // const Center(
                  //   child: Text("Home screen! Logged in"),
                  // ),
                  // SizedBox(
                  //   height: 16.h,
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      User? user = context.read<AuthService>().getUser;
                      DebugLog.myLog(user?.uid.toString() ?? "null user");

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
        } else {
          return const Scaffold(
            body: SafeArea(
                child: Center(
              child: Text("Loading"),
            )),
          );
        }
        // todo: setter display name
        // user.updateDisplayName("long");
      },
    );
  }
}
