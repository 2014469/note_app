import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/note.dart';
import '../resources/constants/str_folder_cloud.dart';
import '../resources/constants/str_note_cloud.dart';
import '../resources/constants/str_user.dart';

class NoteProvider with ChangeNotifier {
  late Note note;
  List<Note> notes = [];

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

  void createNewNote(
      {required String ownerFolderId,
      required String titleNote,
      required String bodyNote}) async {
    final idNote = const Uuid().v1();

    note = Note(
        noteId: idNote,
        body: bodyNote,
        ownerFolderId: ownerFolderId,
        creationDate: Timestamp.now(),
        color: "",
        title: titleNote);
    await getCollectionNote(ownerFolderId).doc(idNote).set(note.toDynamic());

    notes.insert(0, note);
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
        newNotes.add(Note.fromJson(element.data() as Map<String, dynamic>));
      }
    }
    notes = newNotes;
  }
}
