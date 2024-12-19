import 'dart:io';

import 'package:path/path.dart';
import 'package:safe_local_storage/safe_local_storage.dart';

class CacheManager {
  CacheManager() {
    _init();
  }

  /// The path to the cache directory.
  late final String directoryPath;

  void _init() {
    directoryPath = join(Directory.systemTemp.path, 'cache');
    Directory(directoryPath).createSync(recursive: true);
  }

  /// Clears the cache with the specified key.
  ///
  /// If the key exists, all associated files and directories will be deleted.
  ///
  /// [key] is the unique identifier for the cache to be cleared.
  Future<void> clear(String key) async {
    final dir = join(directoryPath, key);
    if (await Directory(dir).exists()) {
      await Directory(dir).delete(recursive: true);
    }
  }

  /// Clears all the cache.
  ///
  /// All the files and directories under the cache directory will be deleted.
  Future<void> clearAll() async {
    if (await Directory(directoryPath).exists()) {
      await Directory(directoryPath).delete(recursive: true);
    }
  }

  /// Writes the cache with the specified key and value.
  ///
  /// The cache will be stored in a file named `[key]/cache.json` under the cache
  /// directory. The file will contain a JSON object with the cache value, the
  /// timestamp when the cache was written, and the cache duration if provided.
  ///
  /// [key] is the unique identifier for the cache.
  ///
  /// [value] is the value to be cached.
  ///
  /// [cacheDuration] is the duration the cache will be valid. If specified, the
  /// cache will be cleared after the duration.
  Future<void> write(
    String key,
    Map<String, dynamic> value, {
    Duration? cacheDuration,
  }) async {
    final storage = SafeLocalStorage(join(directoryPath, key, 'cache.json'));
    await storage.write({
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'cacheDuration': cacheDuration?.inMilliseconds,
    });
  }

  /// Reads the cache with the specified key.
  ///
  /// The cache will be read from the file named `[key]/cache.json` under the
  /// cache directory. The file contains a JSON object with the cache value, the
  /// timestamp when the cache was written, and the cache duration if provided.
  ///
  /// If the cache duration is provided and the cache is expired, the cache
  /// will be cleared and `null` will be returned.
  ///
  /// [key] is the unique identifier for the cache.
  ///
  /// Returns the cached value if the cache is valid, otherwise `null`.
  Future<Map<String, dynamic>?> read(String key) async {
    final storage = SafeLocalStorage(join(directoryPath, key, 'cache.json'));
    final data = await storage.read();
    if (data == null || data.isEmpty) {
      return null;
    }
    final timestamp = data['timestamp'] as int;
    final cacheDuration = data['cacheDuration'] as int?;
    if (cacheDuration != null &&
        DateTime.now().millisecondsSinceEpoch - timestamp > cacheDuration) {
      await clear(key);
      return null;
    }
    return data['value'] as Map<String, dynamic>;
  }
}
