import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.dart';

Future<void> initCacheDI() async {
  // Database initialize.
  final SharedPreferences preference = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(preference);
}
