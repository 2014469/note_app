import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/utils/show_snack_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.provider.dart';
import '../../providers/folder.provider.dart';
import '../../resources/colors/colors.dart';
import '../../resources/constants/asset_path.dart';
import '../../resources/fonts/enum_text_styles.dart';
import '../../resources/fonts/text_styles.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/customLog/debug_log.dart';
import '../../utils/routes/routes.dart';

class DrawerSide extends StatelessWidget {
  const DrawerSide({super.key});

  Widget listTile(
      {required IconData icon, required String title, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 32,
        color: Colors.black54,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProviderValue = Provider.of<UserProvider>(context);
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white54,
                      radius: 43,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            FirebaseAuth.instance.currentUser != null
                                ? NetworkImage(userProviderValue
                                    .getCurrentUser.photoUrl!
                                    .toString())
                                : Image.asset(AssetPaths.logo).image,
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          FirebaseAuth.instance.currentUser != null
                              ? (userProviderValue.getCurrentUser.displayName ==
                                      ""
                                  ? "User"
                                  : userProviderValue
                                      .getCurrentUser.displayName!)
                              : 'Welcome Guest',
                          style: AppTextStyles.h6[TextWeights.semibold],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          height: 25,
                          child: OutlinedButton(
                            onPressed: FirebaseAuth.instance.currentUser == null
                                ? () {
                                    DebugLog.i("Login page");
                                    Navigator.of(context).pushReplacementNamed(
                                        Routes.authWrapper);
                                  }
                                : () {
                                    FolderProvider folderProvider =
                                        Provider.of(context, listen: false);
                                    folderProvider.clearFolders();
                                    context.read<AuthService>().logOUt();
                                  },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              FirebaseAuth.instance.currentUser == null
                                  ? 'Login'.toUpperCase()
                                  : 'Sign out'.toUpperCase(),
                              style: AppTextStyles.body1[TextWeights.medium]!
                                  .copyWith(color: AppColors.gray[80]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              listTile(
                  onTap: (FirebaseAuth.instance.currentUser == null
                      ? () =>
                          showSnackBarInfo(context, "Please login to continue")
                      : () {
                          Navigator.of(context).pushNamed(Routes.infoUser);
                        }),
                  icon: Icons.person,
                  title: "Your profile"),
              listTile(icon: Icons.settings, title: "Settings"),
            ],
          ),
        ),
      ),
    );
  }
}
