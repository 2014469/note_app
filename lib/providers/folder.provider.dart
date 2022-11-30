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

  void fetchAllFolders() async {
    log("fetch review cart");
    log(FirebaseAuth.instance.currentUser?.uid.toString() ?? "afdfdfdf");

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
    required String ownerUserId,
    required String nameFolder,
  }) async {
    final idFolder = const Uuid().v1();
    await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(ownerUserId)
        .collection(FolderCloudConstant.collection)
        .doc(idFolder)
        .set({
      FolderCloudConstant.ownerUserId: ownerUserId,
      FolderCloudConstant.folderId: idFolder,
      FolderCloudConstant.name: nameFolder,
      FolderCloudConstant.dateCreate: Timestamp.now(),
      FolderCloudConstant.isLock: false,
      FolderCloudConstant.passLock: null,
      FolderCloudConstant.color: '#fff',
    });
  }
}
