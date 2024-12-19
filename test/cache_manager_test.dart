import 'package:test/test.dart';
import 'package:simple_cache_manager/simple_cache_manager.dart';

void main() {
  late CacheManager cacheManager;

  setUp(() {
    cacheManager = CacheManager.instance;
  });

  tearDown(() async {
    await cacheManager.clearAll();
  });

  group('CacheManager', () {
    test('write and read cache', () async {
      const key = 'test_key';
      final value = {'test': 'value'};

      await cacheManager.write(key, value);
      final result = await cacheManager.read(key);

      expect(result, value);
    });

    test('cache expiration', () async {
      const key = 'test_key';
      final value = {'test': 'value'};

      await cacheManager.write(
        key,
        value,
        cacheDuration: const Duration(milliseconds: 1),
      );

      await Future.delayed(const Duration(milliseconds: 2));
      final result = await cacheManager.read(key);

      expect(result, null);
    });

    test('clear specific cache', () async {
      const key1 = 'test_key1';
      const key2 = 'test_key2';
      final value = {'test': 'value'};

      await cacheManager.write(key1, value);
      await cacheManager.write(key2, value);

      await cacheManager.clear(key1);

      final result1 = await cacheManager.read(key1);
      final result2 = await cacheManager.read(key2);

      expect(result1, null);
      expect(result2, value);
    });

    test('clear all cache', () async {
      const key1 = 'test_key1';
      const key2 = 'test_key2';
      final value = {'test': 'value'};

      await cacheManager.write(key1, value);
      await cacheManager.write(key2, value);

      await cacheManager.clearAll();

      final result1 = await cacheManager.read(key1);
      final result2 = await cacheManager.read(key2);

      expect(result1, null);
      expect(result2, null);
    });

    test('read non-existent cache', () async {
      const key = 'non_existent_key';
      final result = await cacheManager.read(key);
      expect(result, null);
    });
  });
}
