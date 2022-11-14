import 'package:note_app/models/folder_note.dart';

class Folders {
  static List<Folder> folders = [];
  void printInfo() {
    for (var folder in folders) {
      folder.printInfo();
    }
  }
}
