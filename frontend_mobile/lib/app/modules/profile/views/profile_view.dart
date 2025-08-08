import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/modules/profile/widgets/education_card.dart';
import 'package:frontend_mobile/app/modules/profile/widgets/experience_card.dart';
import 'package:frontend_mobile/app/modules/profile/widgets/personal_card.dart';
import 'package:frontend_mobile/app/modules/profile/widgets/skills_card.dart';
import 'package:frontend_mobile/app/modules/profile/widgets/user_card.dart';
import 'package:frontend_mobile/utils/constant_asset.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
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
            title: Text(
              "Edit Profile",
              style: GoogleFonts.epilogue(
                  fontWeight: FontWeight.w500,
                  fontSize: 20
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: const [
                UserCard(),
                SizedBox(height: 16),
                PersonalInfoCard(),
                SizedBox(height: 16),
                EducationCard(),
                SizedBox(height: 16),
                ExperienceCard(),
                SizedBox(height: 16),
                SkillsCard(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
