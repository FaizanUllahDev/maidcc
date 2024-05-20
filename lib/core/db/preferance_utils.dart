import 'package:hive/hive.dart';
import 'package:maidcc/core/utils/utils.dart';

class PreferencesUtil {
  late Box<dynamic> preferences;

  PreferencesUtil(this.preferences);

  getPreferencesData(String key) {
    return preferences.get(key) ?? "";
  }

  getBoolPreferencesData(String key, {bool defaultValue = false}) {
    return preferences.get(key) ?? defaultValue;
  }

  Future<void> setPreferencesData(String key, String? value) async {
    Utils.debug('$runtimeType   setPreferencesData KEY: $key');
    Utils.debug('$runtimeType   setPreferencesData VALUE: $value');
    // await preferences.setString(key, value ?? "");
    await preferences.put(key, value ?? "");
  }

  setBoolPreferencesData(String key, bool? value) async {
    Utils.debug('$runtimeType   setBoolPreferencesData KEY: $key');
    Utils.debug('$runtimeType   setBoolPreferencesData VALUE: $value');
    // preferences.setBool(key, value ?? false);
    await preferences.put(key, value ?? false);
  }

  Future clearPreferencesData() async {
    await preferences.clear();
  }
}
