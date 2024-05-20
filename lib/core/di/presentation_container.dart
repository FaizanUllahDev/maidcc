import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/di/injection_container.dart';
import 'package:maidcc/core/network/network_info.dart';
import 'package:maidcc/feature/auth/domain/login_respository.dart';
import 'package:maidcc/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:maidcc/feature/home/domain/todo_repository.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_cubit.dart';

Future<void> initPresentationDI() async {
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      sl<LoginRepository>(),
      sl<PreferencesUtil>(),
    ),
  );

  sl.registerFactory<TodoCubit>(
    () => TodoCubit(
      sl<TodoRepository>(),
      sl<NetworkInfo>(),
      sl<PreferencesUtil>(),
    ),
  );
}
