import 'package:flutter/material.dart';
import 'package:frontend_mobile/utils/constant_asset.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailKontenView extends StatelessWidget {
  const DetailKontenView({super.key});

  @override
  Widget build(BuildContext context) {
    final konten = Get.arguments;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            ConstantAssets.imgBg,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    _getImageByCategory(konten.kategori),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "Sumber : ${konten.sumber ?? 'Unknown'}",
                  style: GoogleFonts.epilogue(
                    fontSize: 13,
                    color: const Color.fromRGBO(152, 152, 152, 1.0),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  konten.judul ?? "No Title",
                  style: GoogleFonts.epilogue(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  konten.isi ?? "Tidak ada deskripsi.",
                  style: GoogleFonts.epilogue(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// helper image sesuai kategori
  String _getImageByCategory(String? category) {
    if (category == null) return ConstantAssets.imgKonten2;

    switch (category.toLowerCase()) {
      case 'artikel':
        return ConstantAssets.imgKonten3;
      case 'tips':
        return ConstantAssets.imgKonten2;
      default:
        return ConstantAssets.imgKonten1;
    }
  }
}
