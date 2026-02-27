import '../../../../core/services/network_caller.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../../authentication/data/models/user_model.dart';

class UserService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Calls GET /users/{id} and returns a [UserModel] on success, null on failure.
  Future<UserModel?> getUserById(int id, {String? token}) async {
    final response = await _networkCaller.getRequest(
      ApiConstants.getUserById(id),
      token: token,
    );

    if (response.isSuccess && response.responseData != null) {
      return UserModel.fromJson(response.responseData);
    }
    return null;
  }
}
