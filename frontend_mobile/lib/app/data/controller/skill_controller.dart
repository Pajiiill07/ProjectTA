import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/data/model/skill_model.dart';
import 'package:frontend_mobile/utils/constant_value.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SkillController extends GetxController {
  final isLoading = false.obs;
  final Rxn<SkillModel> _skill = Rxn<SkillModel>();
  final RxList<SkillModel> skillList = <SkillModel>[].obs;

  SkillModel? get skill => _skill.value;
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
      fetchSkill();
    });
  }


  Future<void> fetchSkill() async {
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
      final url = Uri.parse("${ConstantValue.baseUrl}/keahlians/me/all");
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        return;
      }

      print("Fetching skill for user: ${user.userId}");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("skill response status: ${response.statusCode}");
      print("skill response body: ${response.body}");

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

        skillList.clear(); // Kosongkan list sebelumnya
        skillList.addAll(data.map<SkillModel>((item) => SkillModel.fromJson(item)));

        print("skill list loaded: ${skillList.length} item(s)");
      } else if (response.statusCode == 404) {
        skillList.clear();
        print("skill not found (404)");
      } else {
        print("Failed to fetch skill: ${response.statusCode}");
        Get.snackbar("Error", "Gagal mengambil data skill");
      }
    } catch (e) {
      print("Fetch skill error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengambil data skill");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> UpdateSkill({
    required String keahlianId,
    String? namaSkill,
    String? kategori,
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
      final url = Uri.parse("${ConstantValue.baseUrl}/keahlians/me/$keahlianId");
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        Get.snackbar("Error", "Token tidak tersedia");
        return;
      }

      print("Updating skill for user: ${user.userId}");

      final body = {
        "nama_skill": namaSkill,
        "kategori": kategori,
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

      print("Update skill response status: ${response.statusCode}");
      print("Update skill response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedDataUser = SkillModel.fromJson(data);
        _skill.value = updatedDataUser;

        Get.snackbar(
          "Success",
          "skill berhasil diupdate",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Gagal mengupdate skill");
      }
    } catch (e) {
      print("Update skill error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengupdate skill");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSkill({
    required String namaSkill,
    required String kategori,
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

      final url = Uri.parse("${ConstantValue.baseUrl}/keahlians/");

      final body = {
        "nama_skill": namaSkill,
        "kategori": kategori,
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

      print("Add skill status: ${response.statusCode}");
      print("Add skill body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdDataUser = SkillModel.fromJson(data);
        _skill.value = createdDataUser;

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
      print("Add skill error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat menambahkan data");
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk refresh data
  Future<void> refreshData() async {
    await fetchSkill();
  }
}