class NoteStorageException implements Exception {
  const NoteStorageException();
}

// C in CRUD
class CouldNotCreateNoteException extends NoteStorageException {}

// R in CRUD
class CouldNotGetAllNoteException extends NoteStorageException {}

// U in CRUD
class CouldNotUpdateNoteException extends NoteStorageException {}

// D in CRUD
class CouldNotDeleteNoteException extends NoteStorageException {}
