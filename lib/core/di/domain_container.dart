import 'package:maidcc/feature/auth/data/data_source/login_data_source.dart';
import 'package:maidcc/feature/auth/data/repository/login_repo_impl.dart';
import 'package:maidcc/feature/auth/domain/login_respository.dart';
import 'package:maidcc/feature/home/data/data_source/todo_data_source.dart';
import 'package:maidcc/feature/home/data/repository/todo_repository_impl.dart';
import 'package:maidcc/feature/home/domain/todo_repository.dart';

import 'injection_container.dart';

Future<void> initDomainDI() async {
  // REPOSITORY
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      sl<LoginDataSource>(),
    ),
  );

  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      sl<TodoDataSource>(),
    ),
  );
}
