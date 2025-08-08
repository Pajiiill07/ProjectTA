import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
    Get.lazyPut<AuthController>(
          () => AuthController(),
    );
  }
}
