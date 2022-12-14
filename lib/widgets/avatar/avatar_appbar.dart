import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarAppbarWidget extends StatelessWidget {
  final String urlPhoto;
  const AvatarAppbarWidget({super.key, required this.urlPhoto});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 60.r,
      backgroundImage: NetworkImage(urlPhoto),
      backgroundColor: Colors.transparent,
    );
  }
}
