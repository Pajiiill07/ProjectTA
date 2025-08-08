import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/modules/build_cv/widgets/personal_data_form.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPersonalInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Personal Data',
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: PersonalDataForm(
        onNext: () {
          Get.back();
        },
      ),
    );
  }
}