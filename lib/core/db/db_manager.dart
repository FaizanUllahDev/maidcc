import 'package:hive/hive.dart';

import '../config/app_config.dart';

class DBManager {
  // Singleton
  static final DBManager _instance = DBManager._internal();

  factory DBManager() => _instance;

  DBManager._internal();

  // DB

  // open box with name and return it as Future (async) with encrypted cipher with T type data
  Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(
      name,
      encryptionCipher: AppConfig.encryptedCipher,
    );
  }

// end
}
