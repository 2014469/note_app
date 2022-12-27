import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/folder.dart';

class HomeScreenProvider with ChangeNotifier {
  bool isReload = true;
  bool isMultiSelectionMode = false;
  HashSet<Folder> selectedItemsSet = HashSet();

  bool get getReload => isReload;
  bool get getIsMultiSelectionMode => isMultiSelectionMode;

  HashSet<Folder> get getSelectedItemSet => selectedItemsSet;

  void changeReload(bool value) {
    isReload = value;
    notifyListeners();
  }

  void changeIsMultiSelectionMode(bool value) {
    isMultiSelectionMode = value;
    notifyListeners();
  }

  void doMultiSelection(Folder folder) {
    if (selectedItemsSet.contains(folder)) {
      selectedItemsSet.remove(folder);
    } else {
      selectedItemsSet.add(folder);
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

  void addSelection(Folder folder) {
    selectedItemsSet.add(folder);
  }
}
