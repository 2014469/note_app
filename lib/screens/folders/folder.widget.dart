import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:note_app/resources/colors/colors.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/resources/fonts/enum_text_styles.dart';
import 'package:note_app/resources/fonts/text_styles.dart';

import '../../models/folder.dart';
import '../../utils/convert_date/convert_date.dart';

class FolderWidget extends StatefulWidget {
  final Folder folder;
  final Function()? onTap;
  final Function()? onTapSetting;
  final bool isShowMore;
  const FolderWidget({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onTapSetting,
    this.isShowMore = true,
  });

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
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: HexColor.fromHex(widget.folder.color ?? "#F88379"),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 28.w,
            right: 20.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          HexColor.fromHex(widget.folder.color ?? "#F88379")
                              .withOpacity(0.8),
                          BlendMode.modulate),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: SvgPicture.asset(AssetPaths.folderUnlocked),
                      )),
                  widget.isShowMore
                      ? IconButton(
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.all(0),
                          onPressed: widget.onTapSetting,
                          icon: Center(
                            child: Image.asset(
                              AssetPaths.showMore,
                            ),
                          ))
                      : Container(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.folder.name,
                    style: AppTextStyles.h6[TextWeights.semibold]
                        ?.copyWith(color: AppColors.gray[80]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    compareCreateDate(widget.folder.creationDate)
                        ? DateFormat.Hm().format(widget.folder.creationDate)
                        : DateFormat('dd/MM/yyyy').format(widget.folder.creationDate),
                    style: AppTextStyles.caption[TextWeights.bold]!
                        .copyWith(color: AppColors.gray[60]),
                  ),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
