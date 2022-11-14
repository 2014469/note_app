class FolderStorageException implements Exception {
  const FolderStorageException();
}

// C in CRUD
class CouldNotCreateFolderException extends FolderStorageException {}

// R in CRUD
class CouldNotGetAllFolderException extends FolderStorageException {}

// U in CRUD
class CouldNotUpdateFolderException extends FolderStorageException {}

// D in CRUD
class CouldNotDeleteFolderException extends FolderStorageException {}
