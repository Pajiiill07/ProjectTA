import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  UserController get userController => Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    // Debug print untuk cek data user - menggunakan userRx yang exposed
    ever(userController.userRx, (user) {
      print("User data changed: ${user?.username}");
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh user data saat home ready
    if (userController.user == null) {
      final authController = Get.find<AuthController>();
      authController.fetchProfile();
    }
  }
}