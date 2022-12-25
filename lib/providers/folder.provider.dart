import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/folder.dart';
import '../resources/constants/str_folder_cloud.dart';
import '../resources/constants/str_user.dart';

class FolderProvider with ChangeNotifier {
  List<Folder> folders = [];

  List<Folder> get getFolders {
    return folders;
  }

  late Folder folder;

  Future fetchAllFolders() async {
    folders.clear();
    log("fetch folders");
    // log(FirebaseAuth.instance.currentUser?.uid.toString() ?? "afdfdfdf");

    List<Folder> newFolders = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FolderCloudConstant.collection)
        .get();

    if (snapshot.docs.isEmpty) {
      newFolders = [];
    } else {
      for (var element in snapshot.docs) {
        newFolders.add(Folder.fromJson(element.data() as Map<String, dynamic>));
      }
    }
    folders = newFolders;
    notifyListeners();
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
        ownerUserId: FirebaseAuth.instance.currentUser!.uid,
        name: nameFolder,
        isLock: false,
        creationDate: Timestamp.now());
    folder.printInfo();
    await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FolderCloudConstant.collection)
        .doc(idFolder)
        .set(folder.toDynamic());
    folders.insert(0, folder);
    notifyListeners();
  }

  void updateFolder(
    Folder folder,
  ) {
    FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FolderCloudConstant.collection)
        .doc(folder.folderId)
        .update(
          folder.toDynamic(),
        );
  }

  deleteFolder(String idFolder) {
    FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FolderCloudConstant.collection)
        .doc(idFolder)
        .delete();
    notifyListeners();
  }
}
