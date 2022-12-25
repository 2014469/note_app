import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/folder.dart';
import '../resources/constants/str_folder_cloud.dart';
import '../resources/constants/str_user.dart';
import '../utils/customLog/debug_log.dart';
import '../utils/sort/sort_folder.dart';

enum TypeSortFolder { nameInc, nameDec, dateInc, dateDec, colorInc, colorDec }

class FolderProvider with ChangeNotifier {
  static const String _boxName = "folder";

  TypeSortFolder typeSortCurrent = TypeSortFolder.dateDec;

  List<Folder> folders = [];

  List<Folder> get getFolders {
    return folders;
  }

  late Folder folder;

  int i = 0;
  Future fetchAllFolders() async {
    folders.clear();
    DebugLog.i("Fetch folders $i");
    i++;
    // log(FirebaseAuth.instance.currentUser?.uid.toString() ?? "afdfdfdf");

    List<Folder> newFolders = [];

    if (FirebaseAuth.instance.currentUser != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(UserString.userTBL)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FolderCloudConstant.collection)
          .get();
      DebugLog.i("Fetch firebase");
      if (snapshot.docs.isEmpty) {
        newFolders = [];
      } else {
        for (var element in snapshot.docs) {
          newFolders
              .add(Folder.fromJson(element.data() as Map<String, dynamic>));
        }
      }
    } else {
      DebugLog.i("Fetch hive");
      var box = await Hive.openBox<Folder>(_boxName);
      newFolders = box.values.toList();
    }

    folders = newFolders;
    sortOnFetch();
  }

  void addFolders({
    required String nameFolder,
  }) async {
    final idFolder = const Uuid().v1();

    // FolderCloudConstant.ownerUserId: FirebaseAuth.instance.currentUser!.uid,
    // FolderCloudConstant.folderId: idFolder,
    // FolderCloudConstant.name: nameFolder,
    // FolderCloudConstant.dateCreate: Timestamp.now(),
    // FolderCloudConstant.isLock: false,
    // FolderCloudConstant.passLock: null,
    // FolderCloudConstant.color: '#fff',
    folder = Folder(
        folderId: idFolder,
        ownerUserId: FirebaseAuth.instance.currentUser != null
            ? FirebaseAuth.instance.currentUser!.uid
            : "local",
        name: nameFolder,
        isLock: false,
        creationDate: DateTime.now());
    folder.printInfo();
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection(UserString.userTBL)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FolderCloudConstant.collection)
          .doc(idFolder)
          .set(folder.toDynamic());
    } else {
      var box = await Hive.openBox<Folder>(_boxName);
      await box.add(folder);
    }
    folders.insert(0, folder);
    sortOnFetch();
    notifyListeners();
  }

  void updateFolder(
    Folder folder,
  ) {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection(UserString.userTBL)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FolderCloudConstant.collection)
          .doc(folder.folderId)
          .update(
            folder.toDynamic(),
          );
    } else {}

    notifyListeners();
  }

  deleteFolder(String idFolder) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection(UserString.userTBL)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(FolderCloudConstant.collection)
          .doc(idFolder)
          .delete();
    } else {
      var box = await Hive.openBox<Folder>(_boxName);

      final Map<dynamic, Folder> deliveriesMap = box.toMap();
      dynamic desiredKey;
      deliveriesMap.forEach((key, value) {
        if (value.folderId == idFolder) {
          desiredKey = key;
        }
      });

      await box.delete(desiredKey);

      DebugLog.w("Deleted memeber with id $idFolder");
    }
    notifyListeners();
  }

  void sortOnFetch() {
    typeSortCurrent = TypeSortFolder.dateDec;
    sortByDateDecrease(folders);
  }

  void sort(TypeSortFolder typeSort) {
    typeSortCurrent = typeSort;
    switch (typeSortCurrent) {
      case TypeSortFolder.nameInc:
        sortByTitleIncrease(folders);
        break;
      case TypeSortFolder.nameDec:
        sortByTitleDecrease(folders);
        break;
      case TypeSortFolder.dateInc:
        sortByDateIncrease(folders);
        break;
      case TypeSortFolder.dateDec:
        sortByDateDecrease(folders);
        break;
      case TypeSortFolder.colorInc:
        sortByColorTagsIncrease(folders);
        break;
      case TypeSortFolder.colorDec:
        sortByColorTagsDecrease(folders);
        break;
    }
    notifyListeners();
  }
}
