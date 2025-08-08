import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/datauser_controller.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInfoCard extends StatelessWidget {
  const PersonalInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dataUserController = Get.find<DataUserController>();

    return Obx(() {
      final dataUser = dataUserController.dataUser;

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
                  'Personal Information',
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
                      Get.toNamed(Routes.EDIT_PERSONAL);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(253, 255, 241, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mode_edit_outline_outlined, size: 16, color: Color.fromRGBO(45, 43, 40, 1.0)),
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
            const SizedBox(height: 10),

            // Nama Lengkap
            _infoItem("Nama Lengkap", dataUser?.namaLengkap ?? "-"),
            _infoItem("No Handphone", dataUser?.noTelp ?? "-"),
            _infoItem("LinkedIn", dataUser?.linkedin ?? "-"),
            _infoItem("Alamat", dataUser?.alamat ?? "-"),
            _infoItem("Summary", dataUser?.summary ?? "-"),
          ],
        ),
      );
    });
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.epilogue(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(152, 152, 152, 1.0),
            ),
          ),
          Text(
            value.isNotEmpty ? value : "-",
            style: GoogleFonts.epilogue(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
