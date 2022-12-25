import '../../models/note.dart';

void sortByDateIncrease(List<Note> notesSort) {
  notesSort.sort(
    (a, b) {
      return a.creationDate!.compareTo(b.creationDate!);
    },
  );
}

void sortByDateDecrease(List<Note> notesSort) {
  notesSort.sort(
    (b, a) {
      return a.creationDate!.compareTo(b.creationDate!);
    },
  );
}

void sortByTitleIncrease(List<Note> notesSort) {
  notesSort.sort(
    (a, b) {
      return a.title.compareTo(b.title);
    },
  );
}

void sortByTitleDecrease(List<Note> notesSort) {
  notesSort.sort(
    (b, a) {
      return a.title.compareTo(b.title);
    },
  );
}

void sortByColorTagsIncrease(List<Note> notesSort) {
  notesSort.sort(
    (a, b) {
      return a.color!.compareTo(b.color!);
    },
  );
}

void sortByColorTagsDecrease(List<Note> notesSort) {
  notesSort.sort(
    (b, a) {
      return a.color!.compareTo(b.color!);
    },
  );
}
