import 'package:frontend_mobile/app/data/controller/edukonten_controller.dart';
import 'package:get/get.dart';

import '../controllers/detail_konten_controller.dart';

class DetailKontenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailKontenController>(
      () => DetailKontenController(),
    );Get.lazyPut<EdukontenController>(
          () => EdukontenController(),
    );
  }
}
