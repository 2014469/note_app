import 'package:flutter/material.dart';

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
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white54,
                      radius: 43,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            'https://s3.envato.com/files/328957910/vegi_thumb.png'),
                        backgroundColor: Colors.yellow,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Welcome Guest'),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          height: 25,
                          child: OutlinedButton(
                            onPressed: () {},
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
                              'Login'.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              listTile(icon: Icons.home_outlined, title: "Home"),
              listTile(icon: Icons.shopping_cart_outlined, title: "Notes"),
              listTile(
                  icon: Icons.shopping_cart_outlined, title: "Your profile"),
            ],
          ),
        ),
      ),
    );
  }
}
