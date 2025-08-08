import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/modules/build_cv/widgets/education_form.dart';
import 'package:frontend_mobile/app/modules/build_cv/widgets/experience_form.dart';
import 'package:frontend_mobile/app/modules/build_cv/widgets/skill_form.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/build_cv_controller.dart';
import '../widgets/personal_data_form.dart';

class BuildCvView extends GetView<BuildCvController> {
  const BuildCvView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CV Builder',
          style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w500,
              fontSize: 20
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() => CVStepIndicator(
              currentIndex: controller.currentPage.value,
              totalSteps: controller.totalSteps,
            )),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PersonalDataForm(onNext: controller.nextPage),
                EducationForm(onNext: controller.nextPage),
                ExperienceForm(onNext: controller.nextPage),
                SkillForm(onNext: () {
                  final controller = Get.find<BuildCvController>();
                  controller.checkAndGenerate();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CVStepIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;

  const CVStepIndicator({
    super.key,
    required this.currentIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        final isStep = index.isEven;
        final stepIndex = index ~/ 2;

        if (isStep) {
          final isActive = stepIndex <= currentIndex;
          return Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isActive ? const Color.fromRGBO(216, 224, 167, 1.0) : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          );
        } else {
          final isFilled = stepIndex < currentIndex;
          return Expanded(
            child: Container(
              height: 4,
              color: isFilled ? const Color.fromRGBO(216, 224, 167, 1.0) : Colors.grey.shade300,
            ),
          );
        }
      }),
    );
  }
}
