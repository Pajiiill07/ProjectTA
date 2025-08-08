import 'dart:convert';
import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/data/model/datauser_model.dart';
import 'package:frontend_mobile/utils/constant_value.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DataUserController extends GetxController {
  final isLoading = false.obs;
  final Rxn<DataUserModel> _dataUser = Rxn<DataUserModel>();

  DataUserModel? get dataUser => _dataUser.value;

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
      fetchDataUser();
    });
  }

  Future<void> fetchDataUser() async {
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
      final url = Uri.parse("${ConstantValue.baseUrl}/data_users/me/data");
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        return;
      }

      print("Fetching personal info for user: ${user.userId}");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Personal info response status: ${response.statusCode}");
      print("Personal info response body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("Response body is empty");
          _dataUser.value = null;
          return;
        }

        final data = json.decode(response.body);

        // Jika data kosong atau null
        if (data == null || (data is List && data.isEmpty)) {
          _dataUser.value = null;
          print("No personal info found, data is null");
          return;
        }

        // Jika response adalah array, ambil item pertama
        final personalData = data is List ? data.first : data;

        final dataUser = DataUserModel.fromJson(personalData);
        _dataUser.value = dataUser;
        print("Personal info loaded successfully with dataId: ${dataUser.dataId}");

      } else if (response.statusCode == 404) {
        // Data tidak ditemukan
        _dataUser.value = null;
        print("Personal info not found (404)");
      } else {
        print("Failed to fetch personal info: ${response.statusCode}");
        Get.snackbar("Error", "Gagal mengambil data personal info");
      }
    } catch (e) {
      print("Fetch personal info error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengambil data personal info");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDataUser({
    String? namaLengkap,
    String? noHandphone,
    String? linkedin,
    String? alamat,
    String? summary,
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

      // Pastikan ada data yang akan diupdate
      if (_dataUser.value?.dataId == null) {
        print("No existing data to update, switching to add");
        await addDataUser(
          namaLengkap: namaLengkap!,
          noHandphone: noHandphone!,
          linkedin: linkedin ?? '',
          alamat: alamat!,
          summary: summary ?? '',
        );
        return;
      }

      isLoading.value = true;
      final url = Uri.parse("${ConstantValue.baseUrl}/data_users/me");
      final token = authCtrl.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        Get.snackbar("Error", "Token tidak tersedia");
        return;
      }

      print("Updating personal info for user: ${user.userId}");

      final body = <String, dynamic>{};

      if (namaLengkap != null) body["nama_lengkap"] = namaLengkap;
      if (noHandphone != null) body["no_telp"] = noHandphone;
      if (linkedin != null) body["linkedin"] = linkedin;
      if (alamat != null) body["alamat"] = alamat;
      if (summary != null) body["summary"] = summary;

      print("Update body: ${json.encode(body)}");

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      print("Update personal info response status: ${response.statusCode}");
      print("Update personal info response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedDataUser = DataUserModel.fromJson(data);
        _dataUser.value = updatedDataUser;

        Get.snackbar(
          "Success",
          "Personal info berhasil diupdate",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorData = json.decode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Gagal mengupdate personal info");
      }
    } catch (e) {
      print("Update personal info error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengupdate personal info");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDataUser({
    required String namaLengkap,
    required String noHandphone,
    required String linkedin,
    required String alamat,
    required String summary,
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

      final url = Uri.parse("${ConstantValue.baseUrl}/data_users/");

      final body = {
        "nama_lengkap": namaLengkap,
        "no_telp": noHandphone,
        "linkedin": linkedin,
        "alamat": alamat,
        "summary": summary,
      };

      print("Add body: ${json.encode(body)}");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      print("Add personal info status: ${response.statusCode}");
      print("Add personal info body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdDataUser = DataUserModel.fromJson(data);
        _dataUser.value = createdDataUser;

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
      print("Add personal info error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat menambahkan data");
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk refresh data
  Future<void> refreshData() async {
    await fetchDataUser();
  }
}