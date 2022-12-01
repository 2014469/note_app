import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

import '../../models/folder.dart';

class FolderWidget extends StatefulWidget {
  final Folder folder;
  final Function()? onTap;
  final Function()? onTapSetting;
  const FolderWidget(
      {super.key,
      required this.folder,
      required this.onTap,
      required this.onTapSetting});

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(children: [
        Opacity(
          opacity: 0.1,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            // width: 130.w,
            // height: 150.h,
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xff007AFF),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            top: 32.h,
            right: 12.w,
            bottom: 32.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Image.asset(widget.folder.isLock
                  //     ? AssetPaths.folderLocked
                  //     : AssetPaths.folderUnlocked),
                  ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          const Color(0xff007AFF).withOpacity(0.8),
                          BlendMode.modulate),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: SvgPicture.asset(widget.folder.isLock
                            ? AssetPaths.folderLocked
                            : AssetPaths.folderUnlocked),
                      )),
                  IconButton(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(0),
                      onPressed: widget.onTapSetting,
                      icon: Center(
                        child: Image.asset(
                          AssetPaths.showMore,
                        ),
                      ))
                ],
              ),
              Text(
                widget.folder.name,
                style: AppTextStyles.h6[TextWeights.semibold]
                    ?.copyWith(color: AppColors.gray[80]),
              ),
              // Text(
              //   widget.numberOfNote < 2
              //       ? "${widget.numberOfNote} note"
              //       : "${widget.numberOfNote} notes",
              //   style: AppTextStyles.caption[TextWeights.regular]
              //       ?.copyWith(color: AppColors.gray[60]),
              // )
            ],
          ),
        )
      ]),
    );
  }
}
