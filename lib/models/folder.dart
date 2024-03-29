import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/utils/customLog/debug_log.dart';

import '../resources/constants/str_folder_cloud.dart';
import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 1)
class Folder {
  @HiveField(0)
  String folderId;

  @HiveField(1)
  String ownerUserId;

  @HiveField(2)
  String name;

  @HiveField(3)
  bool isLock;

  @HiveField(4)
  String? passLock;

  @HiveField(5)
  DateTime creationDate;

  @HiveField(6)
  String? color;

  Folder({
    required this.folderId,
    required this.ownerUserId,
    required this.name,
    required this.isLock,
    this.passLock,
    required this.creationDate,
    this.color,
  });

  factory Folder.fromJson(Map<String, dynamic> reponseData) {
    return Folder(
      folderId: reponseData[FolderCloudConstant.folderId],
      ownerUserId: reponseData[FolderCloudConstant.ownerUserId],
      name: reponseData[FolderCloudConstant.name],
      isLock: reponseData[FolderCloudConstant.isLock],
      passLock: reponseData[FolderCloudConstant.passLock],
      creationDate: reponseData[FolderCloudConstant.dateCreate].toDate(),
      color: reponseData[FolderCloudConstant.color],
    );
  }

  factory Folder.fromSnapshot(DocumentSnapshot snapshot) {
    return Folder.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toDynamic() {
    return {
      FolderCloudConstant.folderId: folderId,
      FolderCloudConstant.ownerUserId: ownerUserId,
      FolderCloudConstant.name: name,
      FolderCloudConstant.isLock: isLock,
      FolderCloudConstant.passLock: passLock,
      FolderCloudConstant.dateCreate: creationDate,
      FolderCloudConstant.color: color,
    };
  }

  void printInfo() {
    DebugLog.myLog("Id user: $ownerUserId");
    DebugLog.myLog("Id folder: $folderId");
    DebugLog.myLog("Name: $name");
    DebugLog.myLog("Date: $creationDate");
    DebugLog.myLog("isLock: $isLock");
    DebugLog.myLog("pass Lock $passLock");
    DebugLog.myLog("color: $color");
  }
}
