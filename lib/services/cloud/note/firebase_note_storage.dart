import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/resources/constants/str_note_cloud.dart';
import 'package:note_app/services/cloud/folder/folder_storage_exception.dart';

import 'package:note_app/services/cloud/folder/folder_storage_firebase.dart';
import 'package:uuid/uuid.dart';

class NoteFirebaseStorage {
  CollectionReference getCollectionNote(
      String userOwnerId, String folderOwnerId) {
    return FolderFirebaseStorage.getCollectionFolder(userOwnerId)
        .doc(folderOwnerId)
        .collection(NoteCloudConstant.collection);
  }

  Future<void> deleteNote(
      {required String userOwnerId,
      required folderOwnerId,
      required String noteId}) async {
    try {
      await getCollectionNote(userOwnerId, folderOwnerId).doc(noteId).delete();
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

  Future allNotes({
    required String ownerUserId,
    required String folderOwnerId,
  }) async {
    QuerySnapshot snapshot =
        await getCollectionNote(ownerUserId, folderOwnerId).get();
    if (snapshot.docs.isEmpty) {
      // Folders.folders = [];
    } else {
      getFromSnapShot(snapshot);
    }
  }

  getFromSnapShot(QuerySnapshot snapshot) {
    // Notes.notes = [];
    // if (Notes.notes.isEmpty) {
    //   for (var element in snapshot.docs) {
    //     Notes.notes.add(Note.fromJson(element.data() as Map<String, dynamic>));
    //   }
    // } else {
    //   return;
    // }
  }

  Future<Note> createNewNote(
      {required String ownerUserId,
      required String ownerFolderId,
      required String titleNote,
      required String bodyNote}) async {
    final idNote = const Uuid().v1();
    await getCollectionNote(ownerUserId, ownerFolderId).doc(idNote).set({
      NoteCloudConstant.ownerFolderId: ownerFolderId,
      NoteCloudConstant.noteId: idNote,
      NoteCloudConstant.isLock: false,
      NoteCloudConstant.passLock: null,
      NoteCloudConstant.dateCreate: Timestamp.now(),
      NoteCloudConstant.color: "",
      NoteCloudConstant.title: titleNote,
      NoteCloudConstant.body: bodyNote,
    });
    final fetchedFolder =
        await getCollectionNote(ownerUserId, ownerFolderId).doc(idNote).get();
    return Note.fromJson(fetchedFolder.data() as Map<String, dynamic>);
  }

  static final NoteFirebaseStorage _shared =
      NoteFirebaseStorage._sharedInstance();
  NoteFirebaseStorage._sharedInstance();
  factory NoteFirebaseStorage() => _shared;
}
