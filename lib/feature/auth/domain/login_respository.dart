import 'package:maidcc/feature/auth/data/models/user_model.dart';

abstract class LoginRepository {
  Future<UserEntity> login(String username, String password);
}
