import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/modules/build_cv/controllers/cv_preview_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CvPreviewView extends StatelessWidget {
  CvPreviewView({super.key});

  final controller = Get.put(CvPreviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Preview CV',
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Obx(
            () => Stack(
          children: [
            WebViewWidget(controller: controller.webViewController),
            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.downloadCvAsPdf();
        },
        backgroundColor: Color.fromRGBO(216, 224, 167, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.file_download_outlined, color: Color.fromRGBO(45, 43, 40, 1.0),),
      ),
    );
  }
}
