// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 3;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      noteId: fields[0] as String,
      ownerFolderId: fields[1] as String,
      isLock: fields[2] as bool,
      passLock: fields[3] as String?,
      creationDate: fields[4] as DateTime?,
      color: fields[5] as String?,
      title: fields[6] as String,
      body: fields[7] as String?,
      content: fields[8] as String?,
      isPin: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.noteId)
      ..writeByte(1)
      ..write(obj.ownerFolderId)
      ..writeByte(2)
      ..write(obj.isLock)
      ..writeByte(3)
      ..write(obj.passLock)
      ..writeByte(4)
      ..write(obj.creationDate)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.body)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.isPin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
