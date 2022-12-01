import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

class NoteListTileWidget extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  const NoteListTileWidget({
    super.key,
    required this.note,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        vertical: 8.h,
      ),
      leading: ClipOval(
        child: Material(
          color: const Color(0xFFFAE8E3), // Button color
          child: Container(
            margin: EdgeInsets.all(16.w),
            child: Image.asset(AssetPaths.iconNote),
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
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "${note.creationDate.toDate().day}- ${note.creationDate.toDate().month} - ${note.creationDate.toDate().year}",
          style: AppTextStyles.caption[TextWeights.bold]!
              .copyWith(color: AppColors.gray[60]),
        ),
        SizedBox(
          height: 12.h,
        ),
        Container(
          width: 12.w,
          height: 12.w,
          decoration:
              const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        )
      ]),
    );
  }
}
