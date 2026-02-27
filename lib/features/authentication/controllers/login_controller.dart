import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../data/services/auth_service.dart';

class LoginController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  // Loading state
  var isLoading = false.obs;

  // Password visibility
  var isPasswordVisible = false.obs;

  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login function using FakeStore API
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        final username = usernameController.text.trim();
        final password = passwordController.text.trim();

        final response = await _authService.login(
          username: username,
          password: password,
        );

        if (response.isSuccess && response.responseData != null) {
          final data = response.responseData;
          final token = data is Map ? data['token'] : null;

          if (token != null) {
            // Save token and a default user ID (FakeStore login doesn't return user ID,
            // so we'll use "1" as default for demo; the profile screen fetches by ID)
            await StorageService.saveToken(token, '1');

            Get.snackbar(
              'Success',
              'Login successful!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            Get.offAllNamed('/homeScreen');
          } else {
            Get.snackbar(
              'Login Failed',
              'Invalid response from server',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Login Failed',
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Invalid username or password',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Set demo credentials (FakeStore API valid: mor_2314 / 83r5^_)
  void setDemoCredentials() {
    usernameController.text = 'mor_2314';
    passwordController.text = '83r5^_';
  }
}
