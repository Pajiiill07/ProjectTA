import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/datauser_controller.dart';
import 'package:frontend_mobile/app/data/controller/education_controller.dart';
import 'package:frontend_mobile/app/data/controller/experience_controller.dart';
import 'package:frontend_mobile/app/data/controller/skill_controller.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<DataUserController>(
          () => DataUserController(),
    );
    Get.lazyPut<AuthController>(
          () => AuthController(),
    );
    Get.lazyPut<EducationController>(
          () => EducationController(),
    );
    Get.lazyPut<ExperienceController>(
          () => ExperienceController(),
    );
    Get.lazyPut<SkillController>(
          () => SkillController(),
    );
  }
}
