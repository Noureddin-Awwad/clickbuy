import 'package:get_storage/get_storage.dart';

class NLocalStorage {
  final GetStorage _storage;

  // Singleton instance
  static NLocalStorage? _instance;

  // Private constructor initializes storage immediately
  NLocalStorage._internal(this._storage);

  factory NLocalStorage.instance(String bucketName) {
    if (_instance == null) {
      _instance = NLocalStorage._internal(GetStorage(bucketName));
    }
    return _instance!;
  }

  // If needed, add an async init for extra flexibility
  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = NLocalStorage._internal(GetStorage(bucketName));
  }

  // Generic method to save data
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // Generic method to read data
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}