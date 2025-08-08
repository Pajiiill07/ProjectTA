import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/data_check_service.dart';
import 'package:frontend_mobile/app/modules/build_cv/views/build_cv_view.dart';
import 'package:frontend_mobile/app/modules/build_cv/widgets/cv_preview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildCvController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final totalSteps = 4;

  final DataCheckService dataService = DataCheckService();

  void checkAndGenerate() {
    final result = dataService.isUserDataComplete();
    print("DATA CHECK: $result");
    print("DATA PERSONAL: ${GetStorage().read('personalData')}");
    print("DATA EDU: ${GetStorage().read('educationData')}");
    print("DATA EXP: ${GetStorage().read('experienceData')}");
    print("DATA SKILL: ${GetStorage().read('skillData')}");

    if (result) {
      Get.to(() => CvPreviewView());
    }  else {
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_rounded, size: 48, color: Color.fromRGBO(200, 111, 111, 1.0)),
              const SizedBox(height: 12),
              Text(
                'Data Belum Lengkap',
                style: GoogleFonts.epilogue(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(45, 43, 40, 1.0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Silakan lengkapi data pribadi, pendidikan, pengalaman, dan skill Anda terlebih dahulu.',
                style: GoogleFonts.epilogue(fontSize: 14, color: Color.fromRGBO(101, 101, 101, 1.0)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child:  Text(
                  'Nanti',
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  color: Color.fromRGBO(152, 152, 152, 1.0),
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(216, 224, 167, 1.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () {
                Get.back();
                Get.to(() => const BuildCvView());
              },
              child: Text(
                  'Lengkapi',
                style: GoogleFonts.epilogue(
                    fontSize: 14,
                    color: Color.fromRGBO(45, 43, 40, 1.0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  void nextPage() {
    if (currentPage.value < totalSteps - 1) {
      currentPage.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

}
