import 'note.dart';

class Notes {
  static List<Note> notes = [];

  void printInfo() {
    for (var note in notes) {
      note.printInfo();
    }
  }

  void add(Note note) {
    notes.add(note);
  }
}
