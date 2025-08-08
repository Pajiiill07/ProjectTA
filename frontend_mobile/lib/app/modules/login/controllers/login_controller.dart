import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controller/auth_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = Get.find<AuthController>();
  final obscurePassword = true.obs;

  void login() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Validation", "Email and password cannot be empty",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }

    authController.login(email, password);
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
