import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/widgets/app_bar.dart';
import 'package:note_app/widgets/folders/folders.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        handleBackBtn: () {},
        title: "UniNote",
        isBackBtn: false,
      ),
      body: Center(
        child: Column(
          children:  [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: const FolderGrid(isLocked: false,title: "All note",numberOfNote: 3,),
            )
          ],
        ),
      ),
    );
  }
}
