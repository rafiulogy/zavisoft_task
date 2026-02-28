import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../data/services/user_service.dart';

class ProfileController extends GetxController {
  // User data
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userId = ''.obs;
  var userPhone = ''.obs;
  var userFullName = ''.obs;
  var userAddress = ''.obs;

  // Loading state
  var isLoading = false.obs;

  final UserService _userService = UserService();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storedUserId = StorageService.userId;
    if (storedUserId == null) return;

    isLoading.value = true;
    try {
      final id = int.tryParse(storedUserId) ?? 1;
      final user = await _userService.getUserById(
        id,
        token: StorageService.token,
      );

      if (user != null) {
        userName.value = user.username;
        userEmail.value = user.email;
        userId.value = user.id.toString();
        userPhone.value = user.phone;
        userFullName.value = user.fullName;
        userAddress.value = user.address.fullAddress;
      }
    } catch (e) {
      // Fallback to stored data
      userName.value = 'Unknown';
      userEmail.value = 'N/A';
      userId.value = storedUserId;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void logout() {
    StorageService.logoutUser();
    Get.offAllNamed('/loginScreen');
  }
}
