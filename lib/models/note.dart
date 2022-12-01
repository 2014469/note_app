import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/resources/constants/str_note_cloud.dart';
import 'package:note_app/utils/customLog/debug_log.dart';

class Note {
  String noteId;
  String ownerFolderId;
  bool isLock;
  String? passLock;
  Timestamp creationDate;
  String? color;
  String title;
  String? body;
  String? content;

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
  });

  factory Note.fromJson(Map<String, dynamic> reponseData) {
    return Note(
        noteId: reponseData[NoteCloudConstant.noteId],
        ownerFolderId: reponseData[NoteCloudConstant.ownerFolderId],
        isLock: reponseData[NoteCloudConstant.isLock],
        passLock: reponseData[NoteCloudConstant.passLock],
        creationDate: reponseData[NoteCloudConstant.dateCreate],
        color: reponseData[NoteCloudConstant.color],
        title: reponseData[NoteCloudConstant.title],
        body: reponseData[NoteCloudConstant.body],
        content: reponseData[NoteCloudConstant.content]);
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
      NoteCloudConstant.content: content
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
  }
}
