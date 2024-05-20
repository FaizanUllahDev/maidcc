import 'package:maidcc/feature/auth/data/data_source/login_data_source.dart';
import 'package:maidcc/feature/auth/data/models/user_model.dart';
import 'package:maidcc/feature/auth/domain/login_respository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource dataSource;

  LoginRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity> login(String username, String password) {
    return dataSource.login(username, password);
  }
}
