import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.provider.dart';
import '../../resources/colors/colors.dart';
import '../../resources/fonts/enum_text_styles.dart';
import '../../resources/fonts/text_styles.dart';
import '../../services/auth/auth_service.dart';

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
                        backgroundImage: NetworkImage(userProviderValue
                            .getCurrentUser.photoUrl!
                            .toString()),
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          true
                              ? userProviderValue.getCurrentUser.displayName!
                              : 'Welcome Guest',
                          style: AppTextStyles.h5[TextWeights.semibold],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          height: 25,
                          child: OutlinedButton(
                            onPressed: () {
                              false
                                  ? () {}
                                  : context.read<AuthService>().logOUt();
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
                              false
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
              listTile(icon: Icons.person, title: "Your profile"),
              listTile(icon: Icons.settings, title: "Settings"),
            ],
          ),
        ),
      ),
    );
  }
}
