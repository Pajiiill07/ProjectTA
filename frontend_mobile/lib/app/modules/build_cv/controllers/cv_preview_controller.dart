import 'dart:io';

import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/utils/constant_value.dart';
import 'package:http/http.dart' as http;

class CvPreviewController extends GetxController {
  final authController = Get.find<AuthController>();

  late final WebViewController webViewController;
  var isLoading = true.obs;

  final previewUrl = '${ConstantValue.baseUrl}/cv/preview-cv';

  @override
  void onInit() {
    super.onInit();
    _setupWebView();
  }

  void _setupWebView() {
    final token = authController.getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Token tidak tersedia");
      return;
    }

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
          onPageFinished: (_) => isLoading.value = false,
          onWebResourceError: (_) {
            Get.snackbar('Error', 'Gagal memuat CV preview');
          },
        ),
      )
      ..loadRequest(
        Uri.parse(previewUrl),
        headers: {
          'Authorization': "Bearer $token",
        },
      );
  }

  Future<void> downloadCvAsPdf() async {
    try {
      final token = await authController.getToken();

      if (Platform.isAndroid) {
        if (await Permission.storage.isDenied) {
          await Permission.storage.request();
        }

        if (Platform.version.contains("13") || Platform.version.contains("14") || Platform.version.contains("15")) {
          // Android 13+ requires media permissions instead
          await Permission.photos.request(); // OR
          await Permission.videos.request();
          await Permission.audio.request();
        }
      }

      final response = await http.get(
        Uri.parse('${ConstantValue.baseUrl}/cv/generate-cv'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final downloadPath = "${directory!.path}/CV_Preview.pdf";

        final file = File(downloadPath);
        await file.writeAsBytes(response.bodyBytes);

        Get.snackbar('Unduhan Berhasil', 'File berhasil disimpan di $downloadPath');
      } else {
        Get.snackbar('Gagal Mengunduh', 'Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengunduh: $e');
    }

    Get.offNamed(Routes.HOME);
  }
}
