import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_mobile/app/data/controller/skill_controller.dart';

class SkillsCard extends StatelessWidget {
  const SkillsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final skillController = Get.find<SkillController>();

    return Obx(() {
      final hardSkills = skillController.skillList
          .where((s) => s.kategori?.toLowerCase().contains("hard") == true)
          .toList();
      final softSkills = skillController.skillList
          .where((s) => s.kategori?.toLowerCase().contains("soft") == true)
          .toList();

      // Debug print
      print("Total skills: ${skillController.skillList.length}");
      print("Hard skills: ${hardSkills.length}");
      print("Soft skills: ${softSkills.length}");

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromRGBO(216, 224, 167, 1.0),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Text(
                  'Skills',
                  style: GoogleFonts.epilogue(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: const Color.fromRGBO(45, 43, 40, 1.0),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.EDIT_SKILL);
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
            const SizedBox(height: 16),

            /// Hard Skills Section
            if (hardSkills.isNotEmpty) ...[
              _buildSkillSection(
                title: "Hard Skills",
                skills: hardSkills,
              ),
              const SizedBox(height: 16),
            ],

            /// Divider
            if (hardSkills.isNotEmpty && softSkills.isNotEmpty)
              const Divider(
                color: Color.fromRGBO(216, 224, 167, 1.0),
                thickness: 1,
              ),

            if (hardSkills.isNotEmpty && softSkills.isNotEmpty)
              const SizedBox(height: 16),

            /// Soft Skills Section
            if (softSkills.isNotEmpty)
              _buildSkillSection(
                title: "Soft Skills",
                skills: softSkills,
              ),

            /// Empty State
            if (hardSkills.isEmpty && softSkills.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Belum ada skills yang ditambahkan',
                    style: GoogleFonts.epilogue(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildSkillSection({
    required String title,
    required List skills,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Header with Title and Edit Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: const Color.fromRGBO(45, 43, 40, 1.0),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),

        /// Skills Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map<Widget>((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(242, 244, 247, 1.0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.transparent,
                  width: 0,
                ),
              ),
              child: Text(
                skill.namaSkill ?? "-",
                style: GoogleFonts.epilogue(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(52, 64, 84, 1.0),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}