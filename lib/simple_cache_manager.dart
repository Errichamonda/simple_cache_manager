import 'dart:io';

import 'package:path/path.dart';
import 'package:safe_local_storage/safe_local_storage.dart';

class CacheManager {
  CacheManager._() {
    init();
  }

  static final instance = CacheManager._();

  late final String directoryPath;

  void init() {
    directoryPath = join(Directory.systemTemp.path, 'cache');
    Directory(directoryPath).createSync(recursive: true);
  }

  Future<void> clear(String key) async {
    final dir = join(directoryPath, key);
    if (await Directory(dir).exists()) {
      await Directory(dir).delete(recursive: true);
    }
  }

  Future<void> clearAll() async {
    if (await Directory(directoryPath).exists()) {
      await Directory(directoryPath).delete(recursive: true);
    }
  }

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
