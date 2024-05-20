import 'package:maidcc/core/constants.dart';
import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/di/injection_container.dart';
import 'package:maidcc/core/network/network_constants.dart';
import 'package:maidcc/core/network/network_exceptions.dart';
import 'package:maidcc/core/network/network_info.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:dio/dio.dart';

class NetworkClient {
  final Dio dio;

  NetworkClient({required this.dio});

  Future<Response> invoke(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic requestBody,
    bool isBytes = false,
  }) async {
    if (Utils.needRefreshToken()) {
      await invokeRefreshTokenAPI();
    }
    // return if base url is  empty
    if (dio.options.baseUrl.isEmpty) {
      throw ServerException(message: 'Base url is empty');
    }

    if (!(await sl<NetworkInfo>().isConnected)) {
      throw NoInternetException(message: 'Network is not connected');
    }

    Response? response;
    Utils.debug("URL : $url");
    Utils.debug("BODY : $requestBody");
    Utils.debug("QUERY : $queryParameters");

    try {
      if (isBytes) {
        response = await dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(
            responseType: ResponseType.bytes,
            headers: headers,
          ),
        );
        return response;
      }
      switch (requestType) {
        case RequestType.get:
          response = await dio.get(url,
              queryParameters: queryParameters,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          break;
        case RequestType.post:
          response = await dio.post(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          break;
        case RequestType.put:
          response = await dio.put(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          break;
        case RequestType.delete:
          response = await dio.delete(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          break;
        case RequestType.patch:
          response = await dio.patch(url,
              queryParameters: queryParameters,
              data: requestBody,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          break;
      }

      Utils.debug("Response : $response");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response;
      }

      throw GeneralException(message: 'Something went wrong!');
    } on DioError catch (dioError) {
      Utils.debug('$runtimeType on DioError:-  $dioError', StackTrace.current);
      throw _handleError(dioError);
    } on SocketException catch (exception) {
      Utils.debug(
          '$runtimeType on SocketException:-  $exception', StackTrace.current);

      rethrow;
    }
  }

  /// @note: This api function is just used for authorize token before calling any api.
  Future<Response> invokeAuthorizeAPI({
    Map<String, dynamic>? queryParameters,
  }) async {
    String url = kAuthorizeAPI;
    Response? response;
    Utils.debug(kAuthorizeAPI);
    try {
      response = await sl<Dio>().post(
        url,
        data: queryParameters,
      );
      sl<PreferencesUtil>()
        ..setPreferencesData(
          AppKeyConstants.authKey,
          response.data['token'],
        )
        ..setPreferencesData(
          AppKeyConstants.dateTimeLogged,
          DateTime.now().toIso8601String(),
        );
      Utils.debug("$response");
      return response;
    } on DioException catch (dioError) {
      throw _handleError(dioError);
    } on SocketException {
      rethrow;
    }
  }

  // refresh token
  Future<Response> invokeRefreshTokenAPI() async {
    String url = kRefreshAPI;
    Response? response;
    Utils.debug(kRefreshAPI);
    try {
      final token = sl<PreferencesUtil>().getPreferencesData(
        AppKeyConstants.authKey,
      );
      response = await sl<Dio>().post(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      sl<PreferencesUtil>()
        ..setPreferencesData(
          AppKeyConstants.authKey,
          response.data['token'],
        )
        ..setPreferencesData(
          AppKeyConstants.dateTimeLogged,
          DateTime.now().toIso8601String(),
        );
      Utils.debug("$response");
      return response;
    } on DioException catch (dioError) {
      throw _handleError(dioError);
    } on SocketException {
      rethrow;
    }
  }

  MyException _handleError(DioError dioError) {
    try {
      final error = dioError.response?.data != null
          ? (dioError.response!.data as Map<String, dynamic>)
          : null;
      switch (dioError.response?.statusCode) {
        case 400:
          return BadRequestException(
              message: error?['error_description'] ??
                  '400: The resource does not exist!');
        case 405:
          return NotFoundException(
              message: dioError.message ?? '405: The resource does not exist!');
        case 500:
        default:
          return ServerException(
            message: error?['error'] ?? 'Server is not responding!',
          );
      }
    } catch (e) {
      return GeneralException(
        message: e.toString(),
      );
    }
  }
}

enum RequestType { get, post, put, delete, patch }
