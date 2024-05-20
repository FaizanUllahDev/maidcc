
class MyException {
  final String message;

  const MyException({required this.message});
}

class NoInternetException extends MyException {
  NoInternetException({required super.message});
}

// server error
class ServerException extends MyException {
  ServerException({required super.message});
}

// cache error
class CacheException extends MyException {
  CacheException({required super.message});
}

// SocketException
class SocketException extends MyException {
  SocketException({required super.message});
}

// dio error
class DioExceptionNetwork extends MyException {
  DioExceptionNetwork({required super.message});
}

class NotFoundException extends MyException {
  NotFoundException({required super.message});
}

class BadRequestException extends MyException {
  BadRequestException({required super.message});
}

class GeneralException extends MyException {
  GeneralException({required super.message});
}

// exception handler in extension
// extension ExceptionHandler on Exception {
//   String get message {
//     switch (runtimeType) {
//       case NoInternetException:
//         return AppStrings.noInternetConnection;
//       case ServerException:
//         return AppStrings.serverError;
//       case CacheException:
//         return 'Cache Error';
//       case DioExceptionNetwork:
//         return 'Dio Error';
//       case SocketException:
//         return 'Socket Error';
//       case UnauthorizedException:
//         return 'Authentication failed';
//       case NotFoundException:
//         return 'The requested resource could not be found on the server.';
//
//       default:
//         return 'Unknown Error';
//     }
//   }
// }
