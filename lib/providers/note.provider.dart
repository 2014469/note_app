import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/note.dart';
import '../resources/constants/str_folder_cloud.dart';
import '../resources/constants/str_note_cloud.dart';
import '../resources/constants/str_user.dart';
import '../utils/customLog/debug_log.dart';
import '../utils/sort/sort_note.dart';

enum TypeSortNote { titleInc, titleDec, dateInc, dateDec, colorInc, colorDec }

class NoteProvider with ChangeNotifier {
  static const String _boxName = "note_notes";

  late Note note;
  int index = 0;

  TypeSortNote typeSortCurrent = TypeSortNote.dateDec;
  List<Note> notes = [];
  List<Note> pinNotes = [];
  List<Note> unPinNotes = [];

  List<Note> get getPinNotes => pinNotes;
  List<Note> get getUnPinNotes => unPinNotes;

  List<Note> get getNotes {
    return notes;
  }

  TypeSortNote get getTypeSortCurrent => typeSortCurrent;
  int get getLengthPins => pinNotes.length;
  int get getLengthUnPins => unPinNotes.length;
  int get getLengthAllNotes => notes.length;

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

  Future<Note> createNewNote({
    required String ownerFolderId,
    required String titleNote,
    required String bodyNote,
    required String content,
    required String noteId,
  }) async {
    note = Note(
        noteId: noteId,
        body: bodyNote,
        ownerFolderId: ownerFolderId,
        creationDate: DateTime.now(),
        color: '#ffff5252',
        content: content,
        title: titleNote);

    if (FirebaseAuth.instance.currentUser != null) {
      await getCollectionNote(ownerFolderId).doc(noteId).set(note.toDynamic());
    } else {
      var box = await Hive.openBox<Note>(_boxName);
      await box.add(note);
    }

    if (note.isPin) {
      pinNotes.insert(0, note);
    } else {
      unPinNotes.insert(0, note);
    }
    notes.insert(0, note);
    sortOnFetch();
    notifyListeners();
    return note;
  }

  Future<Note> createNewNoteForMove(
      {required String ownerFolderId, required Note note}) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await getCollectionNote(ownerFolderId)
          .doc(note.noteId)
          .set(note.toDynamic());
    } else {
      var box = await Hive.openBox<Note>(_boxName);

      int indexNote = box.values.toList().indexOf(note);
      Note noteUpdate = note;
      noteUpdate.ownerFolderId = ownerFolderId;

      await box.putAt(indexNote, noteUpdate);
    }

    return note;
  }

  deleteNoteLocalByFolderId(String ownerFolderId) async {}

  deleteNote(String ownerFolderId, String noteId) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await getCollectionNote(ownerFolderId).doc(noteId).delete();
    } else {
      var box = await Hive.openBox<Note>(_boxName);

      final Map<dynamic, Note> deliveriesMap = box.toMap();
      dynamic desiredKey;
      deliveriesMap.forEach((key, value) {
        if (value.noteId == noteId && value.ownerFolderId == ownerFolderId) {
          desiredKey = key;
        }
      });

      await box.delete(desiredKey);

      DebugLog.w("Deleted memeber with id $ownerFolderId && note id: $noteId");
    }
    notifyListeners();
  }

  Future<void> fetchAllNotes(String ownerFolder) async {
    DebugLog.i("$index: fetch notes");
    log(FirebaseAuth.instance.currentUser?.uid.toString() ?? "afdfdfdf");

    index++;
    List<Note> newNotes = [];

    List<Note> newPinNotes = [];
    List<Note> newUnPinNotes = [];

    if (FirebaseAuth.instance.currentUser != null) {
      DebugLog.w("note firebase");
      QuerySnapshot snapshot = await getCollectionNote(ownerFolder).get();

      if (snapshot.docs.isEmpty) {
        newNotes = [];
        newPinNotes = [];
        newUnPinNotes = [];
      } else {
        for (var element in snapshot.docs) {
          Note noteTmp = Note.fromJson(element.data() as Map<String, dynamic>);
          if (noteTmp.isPin) {
            newPinNotes.add(noteTmp);
          } else {
            newUnPinNotes.add(noteTmp);
          }
          newNotes.add(noteTmp);
        }
      }
    } else {
      DebugLog.w("note hive");
      var box = await Hive.openBox<Note>(_boxName);
      newNotes = box.values
          .toList()
          .where((element) => element.ownerFolderId == ownerFolder)
          .toList();
      for (var element in newNotes) {
        if (element.isPin) {
          newPinNotes.add(element);
        } else {
          newUnPinNotes.add(element);
        }
      }
    }

    notes = newNotes;
    pinNotes = newPinNotes;
    unPinNotes = newUnPinNotes;
    sortOnFetch();
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

  void sortOnFetch() {
    typeSortCurrent = TypeSortNote.dateDec;
    sortByDateDecrease(notes);
    sortByDateDecrease(pinNotes);
    sortByDateDecrease(unPinNotes);
  }

  void sort(TypeSortNote typeSort) {
    typeSortCurrent = typeSort;
    switch (typeSortCurrent) {
      case TypeSortNote.titleInc:
        sortByTitleIncrease(notes);
        sortByTitleIncrease(pinNotes);
        sortByTitleIncrease(unPinNotes);
        break;
      case TypeSortNote.titleDec:
        sortByTitleDecrease(notes);
        sortByTitleDecrease(pinNotes);
        sortByTitleDecrease(unPinNotes);
        break;
      case TypeSortNote.dateInc:
        sortByDateIncrease(notes);
        sortByDateIncrease(pinNotes);
        sortByDateIncrease(unPinNotes);
        break;
      case TypeSortNote.dateDec:
        sortByDateDecrease(notes);
        sortByDateDecrease(pinNotes);
        sortByDateDecrease(unPinNotes);
        break;
      case TypeSortNote.colorInc:
        sortByColorTagsIncrease(notes);
        sortByColorTagsIncrease(pinNotes);
        sortByColorTagsIncrease(unPinNotes);
        break;
      case TypeSortNote.colorDec:
        sortByColorTagsDecrease(notes);
        sortByColorTagsDecrease(pinNotes);
        sortByColorTagsDecrease(unPinNotes);
        break;
    }
    notifyListeners();
  }

  void setDefaultValue() {
    notes = [];
    pinNotes = [];
    unPinNotes = [];
    typeSortCurrent = TypeSortNote.dateDec;
  }

  void updateNote(String ownerFolderId, Note note) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await getCollectionNote(ownerFolderId).doc(note.noteId).set(
            note.toDynamic(),
          );
    } else {
      var box = await Hive.openBox<Note>(_boxName);

      int indexNote = box.values.toList().indexOf(note);

      await box.putAt(indexNote, note);
    }

    notifyListeners();
  }
}
