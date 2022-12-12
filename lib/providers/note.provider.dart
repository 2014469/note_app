import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/note.dart';
import '../resources/constants/str_folder_cloud.dart';
import '../resources/constants/str_note_cloud.dart';
import '../resources/constants/str_user.dart';

class NoteProvider with ChangeNotifier {
  late Note note;
  List<Note> notes = [];
  List<Note> pinNotes = [];
  List<Note> unPinNotes = [];

  List<Note> get getPinNotes => pinNotes;
  List<Note> get getUnPinNotes => unPinNotes;

  List<Note> get getNotes {
    return notes;
  }

  CollectionReference getCollectionNote(
    String ownerFolderId,
  ) {
    return FirebaseFirestore.instance
        .collection(UserString.userTBL)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FolderCloudConstant.collection)
        .doc(ownerFolderId)
        .collection(NoteCloudConstant.collection);
  }

  Future<Note> createNewNote(
      {required String ownerFolderId,
      required String titleNote,
      required String bodyNote,
      required String content,
      required String noteId}) async {
    note = Note(
        noteId: noteId,
        body: bodyNote,
        ownerFolderId: ownerFolderId,
        creationDate: Timestamp.now(),
        color: "",
        content: content,
        title: titleNote);
    await getCollectionNote(ownerFolderId).doc(noteId).set(note.toDynamic());

    notes.insert(0, note);
    sortByDate();
    notifyListeners();
    return note;
  }

  deleteNote(String ownerFolderId, String noteId) {
    getCollectionNote(ownerFolderId).doc(noteId).delete();
    notifyListeners();
  }

  Future<void> fetchAllNotes(String ownerFolder) async {
    log("fetch notes");
    log(FirebaseAuth.instance.currentUser?.uid.toString() ?? "afdfdfdf");

    List<Note> newNotes = [];

    QuerySnapshot snapshot = await getCollectionNote(ownerFolder).get();

    if (snapshot.docs.isEmpty) {
      newNotes = [];
    } else {
      for (var element in snapshot.docs) {
        Note noteTmp = Note.fromJson(element.data() as Map<String, dynamic>);
        if (noteTmp.isPin) {
          pinNotes.add(noteTmp);
        } else {
          unPinNotes.add(noteTmp);
        }
        newNotes.add(noteTmp);
      }
    }
    notes = newNotes;
    sortByDate();
  }

  void uploadFileToStorage(
      String ownerFolderId, String noteId, String json) async {
    var storage = FirebaseStorage.instance;
    // final List<int> codeUnits = json.codeUnits;

    log("Start upload");
    // final Uint8List unit8List = Uint8List.fromList(codeUnits);
    var taskSnapshot = storage.ref("$ownerFolderId/$noteId").putString(json);

    log("Upload in function");
    log(taskSnapshot.snapshot.ref.getDownloadURL().toString());
  }

  void sortByDate() {
    notes.sort(
      (b, a) {
        return a.creationDate!.compareTo(b.creationDate!);
      },
    );
  }

  void updateNote(String ownerFolderId, Note note) async {
    await getCollectionNote(ownerFolderId).doc(note.noteId).set(
          note.toDynamic(),
        );
  }
}
