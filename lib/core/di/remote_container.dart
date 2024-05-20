import 'package:maidcc/core/di/injection_container.dart';
import 'package:maidcc/core/network/network_client.dart';
import 'package:maidcc/feature/auth/data/data_source/login_data_source.dart';
import 'package:maidcc/feature/home/data/data_source/todo_data_source.dart';

Future<void> initRemoteDI() async {
  sl.registerLazySingleton<LoginDataSource>(
    () => LoginDataSource(
      sl<NetworkClient>(),
    ),
  );

  sl.registerLazySingleton<TodoDataSource>(
    () => TodoDataSource(
      sl<NetworkClient>(),
    ),
  );
}
