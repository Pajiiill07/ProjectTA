import 'package:frontend_mobile/app/data/controller/edukonten_controller.dart';
import 'package:get/get.dart';

import '../controllers/konten_controller.dart';

class KontenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KontenController>(
      () => KontenController(),
    );
    Get.lazyPut<EdukontenController>(
          () => EdukontenController(),
    );
  }
}
