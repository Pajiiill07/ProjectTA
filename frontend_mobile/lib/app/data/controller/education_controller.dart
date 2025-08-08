import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/data/model/education_model.dart';
import 'package:frontend_mobile/utils/constant_value.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EducationController extends GetxController {
  final isLoading = false.obs;
  final Rxn<EducationModel> _education = Rxn<EducationModel>();
  final RxList<EducationModel> educationList = <EducationModel>[].obs;

  EducationModel? get education => _education.value;
  UserController? get userController {
    try {
      return Get.find<UserController>();
    } catch (e) {
      print("UserController not found: $e");
      return null;
    }
  }

  AuthController? get authController {
    try {
      return Get.find<AuthController>();
    } catch (e) {
      print("AuthController not found: $e");
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 100), () {
      fetchEducation();
    });
  }

  // Helper method to format year to full date string
  String formatYearToDate(String year) {
    return "$year-01-01";
  }

  Future<void> fetchEducation() async {
    try {
      final userCtrl = userController;
      final authCtrl = authController;

      if (userCtrl == null || authCtrl == null) {
        print("Required controllers not available");
        return;
      }

      final user = userCtrl.user;
      if (user == null) {
        print("No user found");
        return;
      }

      isLoading.value = true;
      final url = Uri.parse("${ConstantValue.baseUrl}/riwayat_pendidikans/me/all");
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        return;
      }

      print("Fetching educational background for user: ${user.userId}");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("educational background response status: ${response.statusCode}");
      print("educational background response body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("Response body is empty");
          return;
        }

        final data = json.decode(response.body);

        if (data == null || data is! List) {
          print("Unexpected response format: $data");
          return;
        }

        educationList.clear(); // Kosongkan list sebelumnya
        educationList.addAll(data.map<EducationModel>((item) => EducationModel.fromJson(item)));

        print("educational background list loaded: ${educationList.length} item(s)");
      } else if (response.statusCode == 404) {
        educationList.clear();
        print("educational background not found (404)");
      } else {
        print("Failed to fetch educational background: ${response.statusCode}");
        Get.snackbar("Error", "Gagal mengambil data educational background");
      }
    } catch (e) {
      print("Fetch educational background error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengambil data educational background");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> UpdateEducation({
    required String riwayatId,
    String? jenjang,
    String? instansi,
    String? jurusan,
    String? tahunMulai,
    String? tahunSelesai,
  }) async {
    try {
      final userCtrl = userController;
      final authCtrl = authController;

      if (userCtrl == null || authCtrl == null) {
        print("Required controllers not available");
        Get.snackbar("Error", "Controller tidak tersedia");
        return;
      }

      final user = userCtrl.user;
      if (user == null) {
        print("No user found");
        Get.snackbar("Error", "User tidak ditemukan");
        return;
      }

      isLoading.value = true;
      final url = Uri.parse("${ConstantValue.baseUrl}/riwayat_pendidikans/me/$riwayatId");
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        Get.snackbar("Error", "Token tidak tersedia");
        return;
      }

      print("Updating educational background for user: ${user.userId}");

      final body = {
        "jenjang": jenjang,
        "instansi": instansi,
        "jurusan": jurusan,
        // Format tahun menjadi full date string
        "tahun_mulai": tahunMulai != null ? formatYearToDate(tahunMulai) : null,
        "tahun_selesai": tahunSelesai != null ? formatYearToDate(tahunSelesai) : null,
      };

      // Remove null values
      body.removeWhere((key, value) => value == null);

      print("Update body: ${json.encode(body)}"); // Debug log

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      print("Update educational background response status: ${response.statusCode}");
      print("Update educational background response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedDataUser = EducationModel.fromJson(data);
        _education.value = updatedDataUser;

        Get.snackbar(
          "Success",
          "educational background berhasil diupdate",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Gagal mengupdate educational background");
      }
    } catch (e) {
      print("Update educational background error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengupdate educational background");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addEducation({
    required String jenjang,
    required String instansi,
    required String jurusan,
    required String tahunMulai,
    required String tahunSelesai,
  }) async {
    try {
      final userCtrl = userController;
      final authCtrl = authController;

      if (userCtrl == null || authCtrl == null) {
        print("Required controllers not available");
        Get.snackbar("Error", "Controller tidak tersedia");
        return;
      }

      final user = userCtrl.user;
      if (user == null) {
        Get.snackbar("Error", "User tidak ditemukan");
        return;
      }

      isLoading.value = true;
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Token tidak tersedia");
        return;
      }

      final url = Uri.parse("${ConstantValue.baseUrl}/riwayat_pendidikans/");

      final body = {
        "jenjang": jenjang,
        "instansi": instansi,
        "jurusan": jurusan,
        // Format tahun menjadi full date string
        "tahun_mulai": formatYearToDate(tahunMulai),
        "tahun_selesai": formatYearToDate(tahunSelesai),
      };

      print("Add body: ${json.encode(body)}"); // Debug log

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      print("Add educational background status: ${response.statusCode}");
      print("Add educational background body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdDataUser = EducationModel.fromJson(data);
        _education.value = createdDataUser;

        Get.snackbar(
          "Sukses",
          "Data personal berhasil ditambahkan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final error = json.decode(response.body);
        Get.snackbar("Gagal", error['detail'] ?? "Gagal menambahkan data");
      }
    } catch (e) {
      print("Add educational background error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat menambahkan data");
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk refresh data
  Future<void> refreshData() async {
    await fetchEducation();
  }
}