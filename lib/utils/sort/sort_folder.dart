import '../../models/folder.dart';

void sortByDateIncrease(List<Folder> folderSorts) {
  folderSorts.sort(
    (a, b) {
      return a.creationDate.compareTo(b.creationDate);
    },
  );
}

void sortByDateDecrease(List<Folder> folderSorts) {
  folderSorts.sort(
    (b, a) {
      return a.creationDate.compareTo(b.creationDate);
    },
  );
}

void sortByTitleIncrease(List<Folder> folderSorts) {
  folderSorts.sort(
    (a, b) {
      return a.name.compareTo(b.name);
    },
  );
}

void sortByTitleDecrease(List<Folder> folderSorts) {
  folderSorts.sort(
    (b, a) {
      return a.name.compareTo(b.name);
    },
  );
}

void sortByColorTagsIncrease(List<Folder> folderSorts) {
  folderSorts.sort(
    (a, b) {
      return a.color!.compareTo(b.color!);
    },
  );
}

void sortByColorTagsDecrease(List<Folder> folderSorts) {
  folderSorts.sort(
    (b, a) {
      return a.color!.compareTo(b.color!);
    },
  );
}
