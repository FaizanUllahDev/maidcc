import 'package:maidcc/app_main/my_app.dart';

import 'package:flutter/material.dart';
import 'package:maidcc/core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  runApp(const MyApp());
}

