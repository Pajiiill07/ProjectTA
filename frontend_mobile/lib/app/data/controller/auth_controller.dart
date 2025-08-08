import 'dart:convert';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/data/model/auth_model.dart';
import 'package:frontend_mobile/app/data/model/user_model.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:frontend_mobile/utils/constant_value.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  final isLoading = false.obs;
  final token = ''.obs;

  UserController get userController => Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn()) {
      token.value = getToken() ?? '';
      if (token.value.isNotEmpty) {
        fetchProfile();
      }
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final url = Uri.parse("${ConstantValue.baseUrl}/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "username": email.trim(),
          "password": password.trim(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loginResponse = LoginResponseModel.fromJson(data);

        // Simpan token
        token.value = loginResponse.accessToken;
        await box.write('token', token.value);

        // Fetch profile data
        await fetchProfile();

        Get.offAllNamed(Routes.HOME);
      } else {
        final data = json.decode(response.body);
        final detail = data['detail'];

        String errorMessage;

        if (detail is String) {
          errorMessage = detail;
        } else if (detail is List) {
          errorMessage = detail.map((e) => e['msg']).join(', ');
        } else {
          errorMessage = 'Unknown error';
        }

        Get.snackbar("Login Failed", errorMessage,
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      print("Login error: $e"); // Debug print
      Get.snackbar("Error", "Terjadi kesalahan saat login",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfile() async {
    final url = Uri.parse("${ConstantValue.baseUrl}/users/me/profile");

    try {
      final currentToken = getToken();
      if (currentToken == null || currentToken.isEmpty) {
        print("No token available");
        Get.snackbar("Error", "Token tidak tersedia");
        return;
      }

      print("Fetching profile from: $url");
      print("Using token: ${currentToken.substring(0, 10)}...");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $currentToken",
          "Content-Type": "application/json",
        },
      );

      print("Profile response status: ${response.statusCode}");
      print("Profile response headers: ${response.headers}");
      print("Profile response body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("Response body is empty");
          Get.snackbar("Error", "Response kosong dari server");
          return;
        }

        final data = json.decode(response.body);
        print("Parsed JSON data: $data");

        if (data == null) {
          print("Parsed data is null");
          Get.snackbar("Error", "Data tidak valid");
          return;
        }

        final requiredFields = ['user_id', 'username', 'email', 'role'];
        for (String field in requiredFields) {
          if (!data.containsKey(field)) {
            print("Missing required field: $field");
            Get.snackbar("Error", "Data tidak lengkap: field '$field' tidak ditemukan");
            return;
          }
        }

        final user = UserModel.fromJson(data);
        userController.setUser(user);
        print("User data set successfully: ${user.username}");

      } else {
        print("Failed to fetch profile: ${response.statusCode}");
        print("Error response body: ${response.body}");
        Get.snackbar("Failed", "Gagal mengambil data user (${response.statusCode})");
      }
    } on FormatException catch (e) {
      print("JSON Format error: $e");
      Get.snackbar("Error", "Format data tidak valid dari server");
    } on http.ClientException catch (e) {
      print("HTTP Client error: $e");
      Get.snackbar("Error", "Tidak dapat terhubung ke server");
    } catch (e) {
      print("Fetch profile error: $e");
      Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "Semua field harus diisi", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Password dan konfirmasi tidak cocok", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final url = Uri.parse("${ConstantValue.baseUrl}/auth/register");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Registrasi berhasil, silakan login", backgroundColor: Colors.green, colorText: Colors.white);
        Get.offNamed(Routes.LOGIN);
      } else {
        final data = jsonDecode(response.body);
        String errorMessage = data["detail"]?.toString() ?? "Registrasi gagal";
        Get.snackbar("Error", errorMessage, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal koneksi ke server", backgroundColor: Colors.redAccent, colorText: Colors.white);
      print("Register error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void logout() {
    token.value = '';
    userController.clearUser();
    box.erase();
    Get.offAllNamed(Routes.LOGIN);
  }

  bool isLoggedIn() {
    return box.hasData('token') && box.read('token') != null && box.read('token').toString().isNotEmpty;
  }

  String? getToken() {
    return box.read('token');
  }
}