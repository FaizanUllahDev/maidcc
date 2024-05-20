import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:maidcc/core/constants.dart';
import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/network/network_client.dart';
import 'package:maidcc/core/network/network_constants.dart';
import 'package:maidcc/core/network/network_info.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache_container.dart';
import 'domain_container.dart';
import 'presentation_container.dart';
import 'remote_container.dart';

final sl = GetIt.I;

// Must be top-level function
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

Future<void> initDI() async {
  sl.allowReassignment = true;

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  sl.registerSingleton<PreferencesUtil>(PreferencesUtil(
    Hive.box(AppKeyConstants.kPreferencesBox),
  ));

  await initDIO();
  await initCacheDI();
  await initRemoteDI();
  await initDomainDI();
  await initPresentationDI();

  // Network Client.
  sl.registerLazySingleton(
    () => NetworkClient(
      dio: sl(),
    ),
  );
}

Future<void> initDIO() async {
  Dio dio = Dio();
  BaseOptions baseOptions = BaseOptions(
    receiveTimeout: const Duration(milliseconds: 30000),
    connectTimeout: const Duration(milliseconds: 30000),
    baseUrl: kBaseUrl,
    contentType: 'application/json',
    headers: {'Content-Type': 'application/json'},
    maxRedirects: 2,
  );

  dio.options = baseOptions;

  if (!kIsWeb) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
  dio.interceptors.clear();

  (dio.transformer as BackgroundTransformer).jsonDecodeCallback = parseJson;

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioError error, handler) async {
        return handler.next(error);
      },
      onRequest: (RequestOptions requestOptions, handler) async {
        // add bearer token to request options

        requestOptions.headers['Authorization'] =
            'Bearer ${sl<PreferencesUtil>().getPreferencesData(AppKeyConstants.authKey)}';
        Utils.debug(
            "Auth token request options: ${requestOptions.headers['Authorization']}");
        return handler.next(requestOptions);
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
    ),
  );

  sl.registerLazySingleton(() => dio);
}
