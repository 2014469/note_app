import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

import '../../../../resources/constants/asset_path.dart';

class NoteListTileWidget extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  bool isDivider;
  NoteListTileWidget({
    super.key,
    required this.note,
    required this.onTap,
    this.isDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            leading: SizedBox(
              width: 56.w,
              height: 56.w,
              child: ClipOval(
                child: Material(
                  color: const Color(0xFFFAE8E3), // Button color
                  child: Container(
                    margin: EdgeInsets.all(16.w),
                    child: Image.asset(
                      AssetPaths.iconNote,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              note.title,
              style: AppTextStyles.h6[TextWeights.regular]!.copyWith(
                color: AppColors.gray[80],
              ),
            ),
            subtitle: Text(
              note.body ?? "",
              style: AppTextStyles.caption[TextWeights.bold]!.copyWith(
                color: AppColors.gray[60],
              ),
            ),
            trailing: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 16.w,
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "${note.creationDate!.toDate().day}- ${note.creationDate!.toDate().month} - ${note.creationDate!.toDate().year}",
                    style: AppTextStyles.caption[TextWeights.bold]!
                        .copyWith(color: AppColors.gray[60]),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: const BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                  ),
                ],
              ),
            ),
          ),
        ),
        isDivider
            ? Divider(
                height: 1.h,
                thickness: 1.h,
                indent: 88.w,
              )
            : Divider(
                height: 0.h,
                thickness: 0.h,
              )
      ],
    );
  }
}
