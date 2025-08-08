import 'dart:convert';
import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/data/model/edukonten_model.dart';
import 'package:frontend_mobile/utils/constant_value.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EdukontenController extends GetxController {
  final isLoading = false.obs;
  final Rxn<KontenModel> _konten = Rxn<KontenModel>();
  final RxList<KontenModel> KontenList = <KontenModel>[].obs;

  KontenModel? get Konten => _konten.value;
  UserController get userController => Get.find<UserController>();
  AuthController get authController => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchKonten();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchKonten() async {
    try {
      final user = userController.user;
      if (user == null) {
        print("No user found");
        return;
      }

      isLoading.value = true;
      final url = Uri.parse("${ConstantValue.baseUrl}/edu_kontens");
      final token = authController.getToken();

      if (token == null || token.isEmpty) {
        print("No token available");
        return;
      }

      print("Fetching Konten for user: ${user.userId}");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Konten response status: ${response.statusCode}");
      print("Konten response body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("Response body is empty");
          return;
        }

        final data = json.decode(response.body);

        if (data == null || (data is List && data.isEmpty)) {
          _konten.value = KontenModel.empty(user.userId);
          KontenList.clear(); // clear list if empty
          return;
        }

        KontenList.value = (data as List)
            .map((e) => KontenModel.fromJson(e))
            .toList();

        print("Konten loaded successfully: ${KontenList.length} items");

      } else {
        print("Failed to fetch Konten: ${response.statusCode}");
        Get.snackbar("Error", "Gagal mengambil data Konten");
      }
    } catch (e) {
      print("Fetch Konten error: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat mengambil data Konten");
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk refresh data
  Future<void> refreshKonten() async {
    await fetchKonten();
  }

  // Method untuk get konten by ID
  KontenModel? getKontenById(int id) {
    try {
      return KontenList.firstWhere((konten) => konten.kontenId == id);
    } catch (e) {
      return null;
    }
  }

  // Method untuk get konten by kategori
  List<KontenModel> getKontenByKategori(String kategori) {
    return KontenList.where((konten) =>
    konten.kategori?.toLowerCase() == kategori.toLowerCase()).toList();
  }
}