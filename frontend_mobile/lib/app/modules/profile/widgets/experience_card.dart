import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/experience_controller.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final experienceController = Get.find<ExperienceController>();
    final dateFormatYear = DateFormat('yyyy');

    return Obx(() {
      final experienceList = experienceController.experienceList;

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromRGBO(216, 224, 167, 1.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Experience',
                  style: GoogleFonts.epilogue(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.EDIT_EXPERIENCE);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(253, 255, 241, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Color.fromRGBO(216, 224, 167, 1.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.mode_edit_outline_outlined, size: 16, color: Color.fromRGBO(45, 43, 40, 1.0)),
                        const SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: GoogleFonts.epilogue(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(45, 43, 40, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 8),
            ...experienceList.map((experience) {
              final String judul = (experience.judul ?? "-").isNotEmpty ? experience.judul! : "-";
              final String instansi = (experience.instansi ?? "-").isNotEmpty ? experience.instansi! : "-";
              final String tahun = experience.tanggalKegiatan != null
                  ? dateFormatYear.format(experience.tanggalKegiatan!)
                  : "-";
              final String keterangan = (experience.keterangan ?? "-").isNotEmpty ? experience.keterangan! : "-";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        judul,
                        style: GoogleFonts.epilogue(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        instansi,
                        style: GoogleFonts.epilogue(
                          fontSize: 13,
                          color: const Color.fromRGBO(152, 152, 152, 1.0),
                        ),
                      ),
                      Text(
                        tahun,
                        style: GoogleFonts.epilogue(
                          fontSize: 13,
                          color: const Color.fromRGBO(152, 152, 152, 1.0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        keterangan,
                        style: GoogleFonts.epilogue(
                          fontSize: 13,
                          color: const Color.fromRGBO(152, 152, 152, 1.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Color.fromRGBO(216, 224, 167, 1.0)),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}

