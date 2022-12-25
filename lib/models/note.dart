import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/resources/constants/str_note_cloud.dart';
import 'package:note_app/utils/customLog/debug_log.dart';
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 3)
class Note {
  @HiveField(0)
  String noteId;

  @HiveField(1)
  String ownerFolderId;

  @HiveField(2)
  bool isLock;

  @HiveField(3)
  String? passLock;

  @HiveField(4)
  DateTime? creationDate;

  @HiveField(5)
  String? color;

  @HiveField(6)
  String title;

  @HiveField(7)
  String? body;

  @HiveField(8)
  String? content;

  @HiveField(9)
  bool isPin;

  Note.fromId({
    required this.noteId,
    required this.ownerFolderId,
    this.isLock = false,
    this.passLock,
    this.creationDate,
    this.color,
    this.title = "",
    this.body = "",
    this.content = "",
    this.isPin = false,
  });

  Note({
    required this.noteId,
    required this.ownerFolderId,
    this.isLock = false,
    this.passLock,
    required this.creationDate,
    required this.color,
    required this.title,
    this.body = "",
    this.content = "",
    this.isPin = false,
  });

  @override
  bool operator ==(covariant Object other) =>
      identical(this, other) || other is Note && other.noteId == noteId;

  @override
  int get hashCode => noteId.hashCode;

  factory Note.fromJson(Map<String, dynamic> reponseData) {
    return Note(
      noteId: reponseData[NoteCloudConstant.noteId],
      ownerFolderId: reponseData[NoteCloudConstant.ownerFolderId],
      isLock: reponseData[NoteCloudConstant.isLock],
      passLock: reponseData[NoteCloudConstant.passLock],
      creationDate: reponseData[NoteCloudConstant.dateCreate].toDate(),
      color: reponseData[NoteCloudConstant.color],
      title: reponseData[NoteCloudConstant.title],
      body: reponseData[NoteCloudConstant.body],
      content: reponseData[NoteCloudConstant.content],
      isPin: reponseData[NoteCloudConstant.isPin],
    );
  }

  factory Note.fromSnapshot(DocumentSnapshot snapshot) {
    return Note.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Map<String, dynamic> toDynamic() {
    return {
      NoteCloudConstant.noteId: noteId,
      NoteCloudConstant.ownerFolderId: ownerFolderId,
      NoteCloudConstant.isLock: isLock,
      NoteCloudConstant.passLock: passLock,
      NoteCloudConstant.dateCreate: creationDate,
      NoteCloudConstant.color: color,
      NoteCloudConstant.title: title,
      NoteCloudConstant.body: body,
      NoteCloudConstant.content: content,
      NoteCloudConstant.isPin: isPin,
    };
  }

  void printInfo() {
    DebugLog.myLog("Id folder: $ownerFolderId");
    DebugLog.myLog("Id note: $noteId");
    DebugLog.myLog("Title: $title");
    DebugLog.myLog("Body: $body");

    DebugLog.myLog("Date: $creationDate");
    DebugLog.myLog("isLock: $isLock");
    DebugLog.myLog("pass Lock $passLock");
    DebugLog.myLog("color: $color");
    DebugLog.myLog("content $content");
    DebugLog.myLog("isPin $isPin");
  }
}
