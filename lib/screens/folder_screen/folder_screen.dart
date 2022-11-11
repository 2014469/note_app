import 'package:flutter/material.dart';
import 'package:note_app/widgets/app_bar.dart';

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
        title: "UniNote",
        handleBackBtn: () {},
        handleRightBtn: () {},
        isBackBtn: false,
      ),
      
    );
  }
}
