# Simple Cache Manager

A lightweight and efficient caching solution for Dart applications that provides a simple way to cache and retrieve data with optional expiration times.

## Features

- Efficient data storage using [safe_local_storage](https://pub.dev/packages/safe_local_storage)
- Optional cache duration for automatic data expiration
- Selective or complete cache clearing
- Async/await API for smooth integration
- JSON-based storage for structured data

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  simple_cache_manager: ^0.0.1
```

## Usage

```dart
// Get the singleton instance
final cacheManager = CacheManager();

// Write data to cache
await cacheManager.write(
  'user_data',
  {'name': 'John', 'age': 30},
  cacheDuration: Duration(hours: 1), // Optional
);

// Read data from cache
final userData = await cacheManager.read('user_data');
if (userData != null) {
  print(userData['name']); // John
}

// Clear specific cache
await cacheManager.clear('user_data');

// Clear all cache
await cacheManager.clearAll();
```

## How it Works

Simple Cache Manager uses [safe_local_storage](https://pub.dev/packages/safe_local_storage) to store cached data in JSON format. Each cache entry is stored with a timestamp and optional expiration duration. When reading cached data, the manager automatically checks if the data has expired and cleans it up if necessary.

The cache is stored in the system's temporary directory, making it suitable for non-critical data that can be regenerated if needed.

## Features in Detail

### Automatic Cache Expiration

```dart
// Cache data for 1 hour
await cacheManager.write(
  'temporary_data',
  {'status': 'processing'},
  cacheDuration: Duration(hours: 1),
);
```

### Safe Storage

All data is stored using safe_local_storage, which provides atomic write operations and data integrity checks.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
