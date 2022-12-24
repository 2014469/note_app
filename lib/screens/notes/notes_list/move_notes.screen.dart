import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/folder.dart';
import '../../../providers/folder.provider.dart';
import '../../../resources/colors/colors.dart';
import '../../../resources/fonts/enum_text_styles.dart';
import '../../../resources/fonts/text_styles.dart';
import '../../../widgets/bar/app_bar.dart';
import '../../folders/folder.widget.dart';

class MoveNotes extends StatefulWidget {
  String folderIdException;
  MoveNotes({super.key, required this.folderIdException});

  @override
  State<MoveNotes> createState() => _MoveNotesState();
}

class _MoveNotesState extends State<MoveNotes> {
  @override
  Widget build(BuildContext context) {
    FolderProvider folderProviderValue = Provider.of<FolderProvider>(context);

    List<Folder> folders = folderProviderValue.getFolders
        .where((element) => element.folderId != widget.folderIdException)
        .toList();
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppbar(
          isBackBtn: false,
          handleBackBtn: (() {}),
          leadingButton: Container(),
          extraActions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.brightGreen,
                  foregroundColor: AppColors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r), // <-- Radius
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.subtitile[TextWeights.semibold]!
                      .copyWith(color: AppColors.green),
                ),
              ),
            )
          ],
          title: "Move to",
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(16.w),
          child: GridView.builder(
              itemCount: folders.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                Folder folder = folders[index];
                return FolderWidget(
                  isShowMore: false,
                  folder: folder,
                  onTap: () => Navigator.of(context).pop(folder),
                  onTapSetting: () {},
                );
              }),
        )),
      ),
    );
  }
}
