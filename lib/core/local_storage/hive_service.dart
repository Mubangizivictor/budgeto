// core/local_storage/hive_service.dart
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class HiveService {
  // Box names for our local storage
  static const String expenseBox = 'expenses';
  static const String incomeBox = 'income';
  static const String notificationBox = 'notifications';
  static const String settingsBox = 'settings';

  // Initialize Hive and open necessary boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Opening boxes for offline support
    // I'm using dynamic for now since I haven't generated Adapters yet, 
    // but Hive handles Map/JSON perfectly fine too.
    await Hive.openBox(expenseBox);
    await Hive.openBox(incomeBox);
    await Hive.openBox(notificationBox);
    await Hive.openBox(settingsBox);
  }

  // Generic methods to save and get data
  // This helps me keep the codebase clean and reusable
  static Future<void> saveData(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  static dynamic getData(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.get(key);
  }

  static List<dynamic> getAllData(String boxName) {
    final box = Hive.box(boxName);
    return box.values.toList();
  }

  static Future<void> deleteData(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  static Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
