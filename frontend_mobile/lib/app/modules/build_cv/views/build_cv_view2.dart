import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/modules/build_cv/controllers/build_cv_controller.dart';
import 'package:frontend_mobile/app/modules/build_cv/views/build_cv_view.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CvBuilderHomeView extends GetView<BuildCvController> {
  const CvBuilderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'CV Builder',
          style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w500,
              fontSize: 20
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.offNamed(Routes.HOME),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf_outlined, size: 60, color: Color.fromRGBO(
                216, 224, 167, 1.0)),
            const SizedBox(height: 12),
            Text(
              "Bangun CV Profesional",
              style: GoogleFonts.epilogue(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Isi data dirimu lalu langsung generate CV dengan satu klik.",
              textAlign: TextAlign.center,
              style: GoogleFonts.epilogue(
                  fontSize: 13,
                  color: Color.fromRGBO(101, 101, 101, 1.0)
              ),
            ),
            const SizedBox(height: 24),

            /// Tombol Generate CV
            ElevatedButton.icon(
              onPressed: controller.checkAndGenerate,
              icon: const Icon(Icons.download, color: Color.fromRGBO(45, 43, 40, 1.0),),
              label:  Text(
                'Generate CV',
                style: GoogleFonts.epilogue(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Color.fromRGBO(216, 224, 167, 1.0),
                foregroundColor: Color.fromRGBO(45, 43, 40, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Tombol Lengkapi/Edit
            OutlinedButton.icon(
              onPressed: () {
                Get.to(() => const BuildCvView());
              },
              icon: const Icon(Icons.edit, color: Color.fromRGBO(45, 43, 40, 1.0),),
              label: const Text("Lengkapi / Edit Data Saya"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Color.fromRGBO(253, 255, 242, 1.0),
                foregroundColor: Color.fromRGBO(45, 43, 40, 1.0),
                side: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
