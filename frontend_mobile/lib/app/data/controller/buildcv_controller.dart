// import 'package:flutter/material.dart';
// import 'package:frontend_mobile/app/data/controller/datauser_controller.dart';
// import 'package:frontend_mobile/app/data/controller/education_controller.dart';
// import 'package:frontend_mobile/app/data/controller/experience_controller.dart';
// import 'package:frontend_mobile/app/data/controller/skill_controller.dart';
// import 'package:get/get.dart';
//
// class BuildCvController extends GetxController {
//   final PageController pageController = PageController();
//   final RxInt currentPage = 0.obs;
//   final int totalSteps = 4;
//
//   final RxBool isLoadingPersonalData = false.obs;
//   final RxBool isLoadingEducation = false.obs;
//   final RxBool isLoadingExperience = false.obs;
//   final RxBool isLoadingSkill = false.obs;
//
//   final RxBool hasPersonalData = false.obs;
//   final RxBool hasEducationData = false.obs;
//   final RxBool hasExperienceData = false.obs;
//   final RxBool hasSkillData = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     checkExistingData();
//   }
//
//   // Check semua data yang sudah ada
//   Future<void> checkExistingData() async {
//     await Future.wait([
//       checkPersonalData(),
//       checkEducationData(),
//       checkExperienceData(),
//       checkSkillData(),
//     ]);
//   }
//
//   // Check individual data
//   Future<void> checkPersonalData() async {
//     isLoadingPersonalData.value = true;
//     try {
//       // Call your DataUserController atau API
//       final dataUserController = Get.find<DataUserController>();
//       await dataUserController.fetchDataUser();
//       hasPersonalData.value = dataUserController.dataUser?.value != null;
//     } catch (e) {
//       hasPersonalData.value = false;
//     } finally {
//       isLoadingPersonalData.value = false;
//     }
//   }
//
//   Future<void> checkEducationData() async {
//     isLoadingEducation.value = true;
//     try {
//       final educationController = Get.find<EducationController>();
//       await educationController.fetchEducation();
//       hasEducationData.value = educationController.education.isNotEmpty;
//     } catch (e) {
//       hasEducationData.value = false;
//     } finally {
//       isLoadingEducation.value = false;
//     }
//   }
//
//   Future<void> checkExperienceData() async {
//     isLoadingExperience.value = true;
//     try {
//       final experienceController = Get.find<ExperienceController>();
//       await experienceController.fetchExperience();
//       hasExperienceData.value = experienceController.experience.isNotEmpty;
//     } catch (e) {
//       hasExperienceData.value = false;
//     } finally {
//       isLoadingExperience.value = false;
//     }
//   }
//
//   Future<void> checkSkillData() async {
//     isLoadingSkill.value = true;
//     try {
//       final skillController = Get.find<SkillController>();
//       await skillController.fetchSkill();
//       hasSkillData.value = skillController.skill.isNotEmpty;
//     } catch (e) {
//       hasSkillData.value = false;
//     } finally {
//       isLoadingSkill.value = false;
//     }
//   }
//
//   void nextPage() {
//     if (currentPage.value < totalSteps - 1) {
//       currentPage.value++;
//       pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   void previousPage() {
//     if (currentPage.value > 0) {
//       currentPage.value--;
//       pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   // Fungsi untuk check dan generate CV
//   Future<void> checkAndGenerate() async {
//     await checkExistingData();
//
//     if (!hasPersonalData.value || !hasEducationData.value ||
//         !hasExperienceData.value || !hasSkillData.value) {
//       Get.snackbar(
//         "Data Tidak Lengkap",
//         "Silakan lengkapi semua data terlebih dahulu",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     // Redirect ke generate CV
//     await generateCV();
//   }
//
//   Future<void> generateCV() async {
//     try {
//       // Your existing generate CV logic here
//       Get.snackbar(
//         "Success",
//         "CV berhasil di-generate!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Gagal generate CV: ${e.toString()}",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
// }