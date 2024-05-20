import 'package:maidcc/core/network/network_client.dart';
import 'package:maidcc/core/network/network_constants.dart';
import 'package:maidcc/feature/auth/data/models/user_model.dart';

class LoginDataSource {
  final NetworkClient client;

  LoginDataSource(this.client);

  Future<UserEntity> login(String username, String password) async {
    try {
      final response = await client.invokeAuthorizeAPI(
        queryParameters: {
          'username': username,
          'password': password,
        },
      );
      return UserEntity.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
