import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/folder.dart';
import '../../../providers/folder.provider.dart';
import '../../../providers/note_screen.provider.dart';
import '../../../resources/colors/colors.dart';
import '../../../resources/fonts/enum_text_styles.dart';
import '../../../resources/fonts/text_styles.dart';
import '../../../widgets/bar/app_bar.dart';
import '../../folders/folder.widget.dart';

class SelectFolderToMoveNotes extends StatefulWidget {
  final String folderIdException;
  const SelectFolderToMoveNotes({super.key, required this.folderIdException});

  @override
  State<SelectFolderToMoveNotes> createState() =>
      _SelectFolderToMoveNotesState();
}

class _SelectFolderToMoveNotesState extends State<SelectFolderToMoveNotes> {
  late NoteScreenProvider noteScreenProvider;

  @override
  void initState() {
    noteScreenProvider = Provider.of(context, listen: false);
    super.initState();
  }

  void backToScreen() {
    noteScreenProvider.changeReload(false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    FolderProvider folderProviderValue = Provider.of<FolderProvider>(context);

    List<Folder> folders = folderProviderValue.getFolders
        .where((element) => element.folderId != widget.folderIdException)
        .toList();
    return WillPopScope(
      onWillPop: () {
        backToScreen();
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
                  backToScreen();
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
