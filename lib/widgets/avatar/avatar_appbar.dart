import 'package:flutter/material.dart';

class AvatarAppbarWidget extends StatelessWidget {
  final String urlPhoto;
  const AvatarAppbarWidget({super.key, required this.urlPhoto});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.0,
      backgroundImage: NetworkImage(urlPhoto),
      backgroundColor: Colors.transparent,
    );
  }
}
