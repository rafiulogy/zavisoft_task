import '../../../../core/models/response_data.dart';
import '../../../../core/services/network_caller.dart';
import '../../../../core/utils/constants/api_constants.dart';

class AuthService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Calls POST /auth/login with username & password.
  /// Returns [ResponseData] containing the token on success.
  Future<ResponseData> login({
    required String username,
    required String password,
  }) async {
    return await _networkCaller.postRequest(
      ApiConstants.login,
      body: {
        'username': username,
        'password': password,
      },
    );
  }
}
