import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/resources/constants/str_folder_cloud.dart';
import 'package:note_app/resources/constants/str_user.dart';
import 'package:note_app/services/cloud/folder/folder_storage_exception.dart';

import 'package:uuid/uuid.dart';

import '../../../models/folder.dart';

class FolderFirebaseStorage {
  static CollectionReference getCollectionFolder(String userOwnerId) {
    return FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(userOwnerId)
        .collection(FolderCloudConstant.collection);
  }

  Future<void> deleteFolder(
      {required String ownerUserId, required String folderId}) async {
    try {
      await getCollectionFolder(ownerUserId).doc(folderId).delete();
    } catch (e) {
      throw CouldNotDeleteFolderException();
    }
  }

  // Future<void> updateNote({
  //   required String folderId,
  //   required String name,
  //   required String
  // }) async {
  //   try {
  //     await notes.doc(documentId).update({textFieldName: text});
  //   } catch (e) {
  //     throw CouldNotUpdateNoteException();
  //   }
  // }

  Future allFolders({required String ownerUserId}) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(ownerUserId)
        .collection(FolderCloudConstant.collection)
        .get();
    if (snapshot.docs.isEmpty) {
      // Folders.folders = [];
    } else {
      getFromSnapShot(snapshot);
    }
  }

  getFromSnapShot(QuerySnapshot snapshot) {
    // if (Folders.folders.isEmpty) {
    //   for (var element in snapshot.docs) {
    //     Folders.folders
    //         .add(Folder.fromJson(element.data() as Map<String, dynamic>));
    //   }
    // } else {
    //   return;
    // }
  }

  Future<Folder> createNewFolder(
      {required String ownerUserId, required String nameFolder, required String colorString}) async {
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
      FolderCloudConstant.color: colorString,
    });
    final fetchedFolder = await FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(ownerUserId)
        .collection(FolderCloudConstant.collection)
        .doc(idFolder)
        .get();
    return Folder(
        folderId: fetchedFolder[FolderCloudConstant.folderId],
        ownerUserId: ownerUserId,
        name: nameFolder,
        creationDate: fetchedFolder[FolderCloudConstant.dateCreate],
        isLock: fetchedFolder[FolderCloudConstant.isLock],
        passLock: fetchedFolder[FolderCloudConstant.passLock],
        color: fetchedFolder[FolderCloudConstant.color]);
  }

  static final FolderFirebaseStorage _shared =
      FolderFirebaseStorage._sharedInstance();
  FolderFirebaseStorage._sharedInstance();
  factory FolderFirebaseStorage() => _shared;
}
