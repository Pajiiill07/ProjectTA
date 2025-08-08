import 'package:flutter/material.dart';
import 'package:frontend_mobile/utils/constant_asset.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/history_deteksi_controller.dart';

class HistoryDeteksiView extends GetView<HistoryDeteksiController> {
  const HistoryDeteksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              ConstantAssets.imgBg,
              fit: BoxFit.cover,
            ),
          ),

          // Konten
          SafeArea(
            child: Column(
              children: [
                // AppBar custom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Job Detect History',
                        style: GoogleFonts.epilogue(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Job Detection History',
                          style: GoogleFonts.epilogue(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(
                          4,
                              (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _jobCard(
                              title: 'Judul Lowongan',
                              company: 'Nama Perusahaan',
                              description:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam non arcu at tellus dictum dictum. Phasellus egestas ipsum tristique arcu vestibulum, quis tempus ex semper.',
                              reason:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam non arcu at tellus dictum dictum. Phasellus egestas ipsum tristique arcu vestibulum, quis tempus ex semper.',
                              isFake: index % 2 == 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _jobCard({
    required String title,
    required String company,
    required String description,
    required String reason,
    required bool isFake,
  }) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFE9F0D5),
                  child: Icon(Icons.insert_drive_file, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.epilogue(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        company,
                        style: GoogleFonts.epilogue(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    isFake ? 'Palsu' : 'Asli',
                    style: GoogleFonts.epilogue(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor:
                  isFake ? const Color(0xFFC86F6F) : const Color(0xFF6FC86F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Deskripsi Pekerjaan',
              style: GoogleFonts.epilogue(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.epilogue(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              'Alasan',
              style: GoogleFonts.epilogue(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              reason,
              style: GoogleFonts.epilogue(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
