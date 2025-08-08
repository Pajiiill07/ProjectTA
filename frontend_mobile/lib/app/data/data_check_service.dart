import 'package:frontend_mobile/app/data/controller/datauser_controller.dart';
import 'package:frontend_mobile/app/data/controller/education_controller.dart';
import 'package:frontend_mobile/app/data/controller/experience_controller.dart';
import 'package:frontend_mobile/app/data/controller/skill_controller.dart';
import 'package:get/get.dart';

class DataCheckService {
  final dataUserController = Get.find<DataUserController>();
  final educationController = Get.find<EducationController>();
  final experienceController = Get.find<ExperienceController>();
  final skillController = Get.find<SkillController>();

  bool isUserDataComplete() {
    final personal = _isValid(dataUserController.dataUser);
    final education = _isValid(educationController.educationList);
    final experience = _isValid(experienceController.experienceList);
    final skill = _isValid(skillController.skillList);

    return personal && education && experience && skill;
  }

  bool _isValid(dynamic data) {
    if (data == null) return false;
    if (data is List) return data.isNotEmpty;
    if (data is Map) return data.isNotEmpty;
    if (data is String) return data.trim().isNotEmpty;
    return true;
  }
}
