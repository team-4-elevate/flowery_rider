abstract class LocalStorageException implements Exception {
  final String message;

  const LocalStorageException({required this.message});
}

class CacheNotFoundException extends LocalStorageException {
  CacheNotFoundException({String? message})
      : super(message: message ?? 'Requested data not found in cache');
}

class CacheWriteException extends LocalStorageException {
  CacheWriteException({String? message})
      : super(message: message ?? 'Failed to write data to cache');
}

class CacheReadException extends LocalStorageException {
  CacheReadException({String? message})
      : super(message: message ?? 'Failed to read data from cache');
}

class CacheDeleteException extends LocalStorageException {
  CacheDeleteException({String? message})
      : super(message: message ?? 'Failed to delete data from cache');
}
