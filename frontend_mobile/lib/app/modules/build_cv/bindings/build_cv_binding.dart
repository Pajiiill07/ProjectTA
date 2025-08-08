import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/datauser_controller.dart';
import 'package:frontend_mobile/app/data/controller/education_controller.dart';
import 'package:frontend_mobile/app/data/controller/experience_controller.dart';
import 'package:frontend_mobile/app/data/controller/skill_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/modules/build_cv/controllers/cv_preview_controller.dart';
import 'package:get/get.dart';

import '../controllers/build_cv_controller.dart';

class BuildCvBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserController>(UserController(), permanent: true);

    Get.put<AuthController>(AuthController(), permanent: true);

    Get.lazyPut<DataUserController>(
      () => DataUserController(),
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

    Get.lazyPut<BuildCvController>(
      () => BuildCvController(),
    );

    Get.lazyPut<CvPreviewController>(
      () => CvPreviewController(),
    );
  }
}
