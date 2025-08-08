import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/education_controller.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final educationController = Get.find<EducationController>();
    return Obx(() {
      final educationList = educationController.educationList;

      return Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color.fromRGBO(216, 224, 167, 1.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Educational Background',
                  style: GoogleFonts.epilogue(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.EDIT_EDUCATION);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(253, 255, 241, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                            color: Color.fromRGBO(216, 224, 167, 1.0)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mode_edit_outline_outlined,
                            size: 16,
                            color: Color.fromRGBO(45, 43, 40, 1.0)),
                        SizedBox(width: 8),
                        Text(
                          'Edit',
                          style: GoogleFonts.epilogue(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(45, 43, 40, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ...educationList.map((education) {
              final dateFormatYear = DateFormat('yyyy');

              String tahunMulai = education.tahunMulai != null
                  ? dateFormatYear.format(education.tahunMulai!)
                  : "-";

              String tahunSelesai = education.tahunSelesai != null
                  ? dateFormatYear.format(education.tahunSelesai!)
                  : "sekarang";

              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        education.instansi ?? "-",
                        style: GoogleFonts.epilogue(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          if ((education.jurusan ?? "").isNotEmpty)
                            Text(
                              education.jurusan!,
                              style: GoogleFonts.epilogue(
                                fontSize: 13,
                                color: Color.fromRGBO(152, 152, 152, 1.0),
                              ),
                            ),
                          if ((education.jurusan ?? "").isNotEmpty)
                            SizedBox(width: 5),
                          if ((education.jurusan ?? "").isNotEmpty)
                            Icon(Icons.circle,
                                size: 5,
                                color: Color.fromRGBO(152, 152, 152, 1.0)),
                          SizedBox(width: 5),
                          Text(
                            education.jenjang ?? "-",
                            style: GoogleFonts.epilogue(
                              fontSize: 13,
                              color: Color.fromRGBO(152, 152, 152, 1.0),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$tahunMulai - $tahunSelesai',
                        style: GoogleFonts.epilogue(
                          fontSize: 13,
                          color: Color.fromRGBO(152, 152, 152, 1.0),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  Divider(color: Color.fromRGBO(216, 224, 167, 1.0)),
                ],
              );
            }).toList()
          ],
        ),
      );
    });
  }
}
