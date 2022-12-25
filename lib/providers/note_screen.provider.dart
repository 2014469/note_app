import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteScreenProvider with ChangeNotifier {
  bool isReload = true;
  bool isMultiSelectionMode = false;
  HashSet<Note> selectedItemsSet = HashSet();

  bool get getReload => isReload;
  bool get getIsMultiSelectionMode => isMultiSelectionMode;

  HashSet<Note> get getSelectedItemSet => selectedItemsSet;

  void changeReload(bool value) {
    isReload = value;
    notifyListeners();
  }

  void changeIsMultiSelectionMode(bool value) {
    isMultiSelectionMode = value;
    notifyListeners();
  }

  void doMultiSelection(Note note) {
    if (selectedItemsSet.contains(note)) {
      selectedItemsSet.remove(note);
    } else {
      selectedItemsSet.add(note);
    }
    isReload = false;
    notifyListeners();
  }

  void clearMultiSelection() {
    selectedItemsSet.clear();
    isReload = false;
    notifyListeners();
  }

  void clearAndCancelSelectionMode() {
    selectedItemsSet.clear();
    isMultiSelectionMode = false;
    isReload = false;
    notifyListeners();
  }

  void finishSelectionMode() {
    selectedItemsSet.clear();
    isMultiSelectionMode = false;
    isReload = true;
    notifyListeners();
  }

  void addSelection(Note note) {
    selectedItemsSet.add(note);
  }
}
