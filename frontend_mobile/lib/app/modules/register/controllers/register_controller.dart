import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  AuthController get authController => Get.find<AuthController>();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isPasswordMismatch = false.obs;

  void validatePasswords() {
    isPasswordMismatch.value =
        passwordController.text != confirmPasswordController.text;
  }

  void register() {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    authController.register(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
