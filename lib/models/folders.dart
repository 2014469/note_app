import 'package:flutter/material.dart';
import 'package:note_app/models/folder_note.dart';

class Folders extends ChangeNotifier {
  static List<Folder> folders = [];
  void printInfo() {
    for (var folder in folders) {
      folder.printInfo();
    }
  }

  void addFolder(Folder folder) {
    folders.add(folder);
    notifyListeners();
  }
}
