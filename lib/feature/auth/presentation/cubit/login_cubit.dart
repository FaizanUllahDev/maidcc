import 'package:maidcc/core/constants.dart';
import 'package:maidcc/core/cubit/base_cubit.dart';
import 'package:maidcc/feature/auth/presentation/cubit/login_state.dart';
import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/di/injection_container.dart';
import 'package:maidcc/core/enums/enums.dart';
import 'package:maidcc/core/network/network_exceptions.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/feature/auth/data/models/user_model.dart';
import 'package:maidcc/feature/auth/domain/login_respository.dart';

class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit(this.repository, this.preferences) : super(LoginState());

  final LoginRepository repository;

  final PreferencesUtil preferences;

  Future<void> login(String username, String password) async {
    try {
      emit(state.copyWith(status: StatusEnum.loading));

      // calling api method to get the login state.
      final UserEntity user = await repository.login(username, password);

      Utils.debug(user.toString());

      //

      if (user.id! > 0) {
        Utils.currentUser = user;
        preferences.setPreferencesData(
          AppKeyConstants.userKey,
          user.toJson(),
        );
        preferences.setPreferencesData(
          AppKeyConstants.dateTimeLogged,
          DateTime.now().toString(),
        );

        //
        emit(state.copyWith(status: StatusEnum.success));
      }
    } on MyException catch (e) {
      Utils.debug("Error while trying to login ${e.message}");
      emit(state.copyWith(
          status: StatusEnum.failed, message: 'Something went wrong'));
    } catch (e) {
      emit(state.copyWith(
          status: StatusEnum.failed, message: 'Something went wrong'));
    }
  }
}
