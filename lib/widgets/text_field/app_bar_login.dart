import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/colors/colors.dart';

class CustomAppbarLogin extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final VoidCallback handleBackBtn;

  const CustomAppbarLogin({
    super.key,
    this.backgroundColor = AppColors.background,
    required this.handleBackBtn,
  });

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      
      leadingWidth: 92.w,
      leading: 
           InkWell(
              onTap: handleBackBtn,
              
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, right: 0),
                
                child: Row(children:[
                   Icon(
                    Icons.arrow_back_ios_new,
                    size: 28.w,
                    color: AppColors.primary,
                  ),
                ]),
              ),
            ),
          

    );
  }
}
