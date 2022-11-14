import 'package:flutter/material.dart';
import 'package:note_app/widgets/app_bar.dart';

class ListNotesScreen extends StatelessWidget {
  const ListNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        handleBackBtn: () => {},
      ),
    );
  }
}
