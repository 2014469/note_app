import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:note_app/resources/constants/asset_path.dart';
import 'package:note_app/widgets/app_bar.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final List<Map<String, dynamic>> myFolders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        handleBackBtn: () {},
        title: "UniNote",
        isBackBtn: false,
      ),
      body: SafeArea(child: Center(child: Center(child: ))),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 104.h, right: 44.w),
        child: FloatingActionButton(
          onPressed: () {},
          child: Image.asset(AssetPaths.addFolder),
        ),
      ),
    );
  }
}
