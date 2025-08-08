import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/model/user_model.dart';
import 'package:frontend_mobile/utils/constant_value.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class UserController extends GetxController {
  final Rxn<UserModel> _user = Rxn<UserModel>();
  final isLoading = false.obs;

  UserModel? get user => _user.value;
  Rxn<UserModel> get userRx => _user;

  void setUser(UserModel user) {
    _user.value = user;
    print("User set in controller: ${user.username}");
  }

  void clearUser() {
    _user.value = null;
    print("User cleared from controller");
  }

  Future<bool> updateUser({
    required String username,
    required String email,
    String? password,
    File? photoFile,
  }) async {
    try {
      isLoading.value = true;

      final user = this.user;
      if (user == null) {
        Get.snackbar("Error", "User tidak ditemukan");
        return false;
      }

      final token = getToken();
      if (token == null) {
        Get.snackbar("Error", "Token tidak ditemukan");
        return false;
      }

      final url = Uri.parse("${ConstantValue.baseUrl}/users/me");

      var request = http.MultipartRequest('PUT', url)
        ..headers['Authorization'] = 'Bearer $token';

      // Field form
      request.fields['username'] = username;
      request.fields['email'] = email;
      if (password != null) request.fields['password'] = password;

      // Jika ada foto
      if (photoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            photoFile.path,
            filename: path.basename(photoFile.path),
          ),
        );
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        final updatedUser = UserModel.fromJson(data);
        setUser(updatedUser);

        Get.snackbar(
          "Sukses",
          "Profil berhasil diperbarui",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        final error = json.decode(respStr);
        Get.snackbar("Gagal", error['detail'] ?? 'Gagal update profil');
        return false;
      }
    } catch (e) {
      print("Update user error: $e");
      Get.snackbar("Error", "Kesalahan jaringan");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String? getToken() {
    return GetStorage().read('token');
  }
}