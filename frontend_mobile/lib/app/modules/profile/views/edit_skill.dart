import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/modules/build_cv/widgets/skill_form.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSkill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Skill',
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
      body: SkillForm(
        onNext: () {
          Get.back();
        },
      ),
    );
  }
}