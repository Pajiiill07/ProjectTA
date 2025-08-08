import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/data/model/experience_model.dart';
import 'package:frontend_mobile/utils/constant_value.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ExperienceController extends GetxController {
  final isLoading = false.obs;
  final Rxn<ExperienceModel> _experience = Rxn<ExperienceModel>();
  final RxList<ExperienceModel> experienceList = <ExperienceModel>[].obs;

  ExperienceModel? get experience => _experience.value;
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
      fetchExperience();
    });
  }

  // Helper method to format year to full date string
  String formatYearToDate(String year) {
    return "$year-01-01";
  }

  Future<void> fetchExperience() async {
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
      final url = Uri.parse("${ConstantValue.baseUrl}/pengalamans/me/all");
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        return;
      }

      print("Fetching Experience for user: ${user.userId}");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Experience response status: ${response.statusCode}");
      print("Experience response body: ${response.body}");

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

        experienceList.clear(); // Kosongkan list sebelumnya
        experienceList.addAll(data.map<ExperienceModel>((item) => ExperienceModel.fromJson(item)));

        print("Experience list loaded: ${experienceList.length} item(s)");
      } else if (response.statusCode == 404) {
        experienceList.clear();
        print("Experience not found (404)");
      } else {
        print("Failed to fetch Experience: ${response.statusCode}");
        Get.snackbar("Error", "Gagal mengambil data Experience");
      }
    } catch (e) {
      print("Fetch Experience error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengambil data Experience");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> UpdateExperience({
    required String pengalamanId,
    String? judul,
    String? instansi,
    String? tanggalKegiatan,
    String? keterangan,
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
      final url = Uri.parse("${ConstantValue.baseUrl}/pengalamans/me/$pengalamanId");
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        Get.snackbar("Error", "Token tidak tersedia");
        return;
      }

      print("Updating Experience for user: ${user.userId}");

      final body = {
        "judul": judul,
        "instansi": instansi,
        "tanggal_kegiatan": tanggalKegiatan != null ? formatYearToDate(tanggalKegiatan) : null,
        "keterangan": keterangan,
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

      print("Update Experience response status: ${response.statusCode}");
      print("Update Experience response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedDataUser = ExperienceModel.fromJson(data);
        _experience.value = updatedDataUser;

        Get.snackbar(
          "Success",
          "Experience berhasil diupdate",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Gagal mengupdate Experience");
      }
    } catch (e) {
      print("Update Experience error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengupdate Experience");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExperience({
    required String judul,
    required String instansi,
    required String tanggalKegiatan,
    required String keterangan,
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

      final url = Uri.parse("${ConstantValue.baseUrl}/pengalamans/");

      final body = {
        "judul": judul,
        "instansi": instansi,
        "tanggal_kegiatan": formatYearToDate(tanggalKegiatan),
        "keterangan": keterangan,
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

      print("Add Experience status: ${response.statusCode}");
      print("Add Experience body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdDataUser = ExperienceModel.fromJson(data);
        _experience.value = createdDataUser;

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
      print("Add Experience error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat menambahkan data");
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk refresh data
  Future<void> refreshData() async {
    await fetchExperience();
  }
}