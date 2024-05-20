import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maidcc/core/constants.dart';
import 'package:maidcc/core/db/db_manager.dart';
import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/di/cache_container.dart';
import 'package:maidcc/core/di/domain_container.dart';
import 'package:maidcc/core/di/injection_container.dart';
import 'package:maidcc/core/di/remote_container.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/feature/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static HiveAesCipher encryptedCipher = HiveAesCipher([]);

  static init() async {
    // hive init
    await initHive();
    await openBoxes();

    await initDI();

    Utils.debug("Init ");

    if (Utils.needRefreshToken()) {
      Utils.debug("Need refresh token");
      Utils.isUserLogin = false;
      sl<PreferencesUtil>().clearPreferencesData();
    } else {
      final pref = sl<PreferencesUtil>();
      Utils.currentUser = UserEntity.fromJson(
        pref.getPreferencesData(AppKeyConstants.userKey),
      );
      Utils.debug(Utils.currentUser.toString());
      Utils.isUserLogin = Utils.currentUser.id! > 0;
    }
  }

  static Future<void> initHive() async {
    // hive init
    Hive.initFlutter();

    // secure storage init

    const FlutterSecureStorage secureStorage = FlutterSecureStorage();

    var containsEncryptionKey = await secureStorage.containsKey(key: 'key');

    final keyValue = (await secureStorage.read(key: 'key')) ?? '';

    var encryptionKey = base64Url.decode(keyValue);

    if (!containsEncryptionKey || keyValue.isEmpty) {
      await clear();
      var key = Hive.generateSecureKey();
      final newValueForStorage = base64UrlEncode(key);
      Utils.debug('Creating new key: $newValueForStorage');
      await secureStorage.write(key: 'key', value: newValueForStorage);

      encryptionKey = base64Url.decode(newValueForStorage);
    }

    encryptedCipher = HiveAesCipher(encryptionKey);

    Utils.debug('Encryption key: $encryptionKey');
  }

  static Future<void> clear() async {
    Utils.debug('clear: Hive and SecureStorage clearing...');

    await Hive.close();

    await Hive.deleteBoxFromDisk(AppKeyConstants.kPreferencesBox);
    // hive clear
    await Hive.deleteFromDisk();
    // secure storage clear
    Utils.debug('clear: Hive and SecureStorage cleared');
  }

  static Future<void> openBoxes() async {
    // open boxes
    DBManager dbManager = DBManager();
    await Future.wait(
      [
        dbManager.openBox(AppKeyConstants.kPreferencesBox),
      ],
    );
  }
}
