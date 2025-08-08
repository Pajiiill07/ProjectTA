import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/skill_controller.dart';
import 'package:frontend_mobile/app/data/model/skill_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class SkillForm extends StatefulWidget {
  final VoidCallback onNext;
  const SkillForm({super.key, required this.onNext});

  @override
  State<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends State<SkillForm> {
  late final SkillController skillController;
  List<SkillData> skillList = [SkillData()];
  final List<String> kategoriList = ['Soft Skill', 'Hard Skill'];

  @override
  void initState() {
    super.initState();
    skillController = Get.find<SkillController>(); // Ambil instance
    loadExistingSkillData();
  }

  void loadExistingSkillData() {
    final existingSkills = skillController.skillList;
    if (existingSkills.isNotEmpty) {
      setState(() {
        skillList.clear();
        skillList.addAll(
          existingSkills.map((skill) => SkillData.fromModel(skill)).toList(),
        );
      });
    }
  }

  void addNewSkill() {
    setState(() {
      skillList.add(SkillData());
    });
  }

  Future<void> saveSkillData(int index) async {
    final skill = skillList[index];
    if (skill.namaSkillController.text.isEmpty || skill.kategori == null) {
      Get.snackbar(
        "Error",
        "Semua field harus diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      if (skill.isExisting) {
        await skillController.UpdateSkill(
          keahlianId: skill.keahlianId.toString(),
          namaSkill: skill.namaSkillController.text,
          kategori: skill.kategori!,
        );
        Get.snackbar(
          "Success",
          "Skill berhasil diupdate",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        await skillController.addSkill(
          namaSkill: skill.namaSkillController.text,
          kategori: skill.kategori!,
        );
        setState(() {
          skill.isExisting = true;
        });
        Get.snackbar(
          "Success",
          "Skill berhasil ditambahkan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      await skillController.refreshData(); // Refresh list
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menyimpan data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skill',
            style: GoogleFonts.epilogue(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Text(
            'Provide details of your skills. Include name and category.',
            style: GoogleFonts.epilogue(
              fontSize: 13,
              color: const Color.fromRGBO(101, 101, 101, 1.0),
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (skillController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return buildSkillList();
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: addNewSkill,
              icon: const Icon(Icons.add, color: Color(0xFF7A8A3A)),
              label: Text(
                'Tambah Skill',
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7A8A3A),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(216, 224, 167, 1.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Next',
                style: GoogleFonts.epilogue(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSkillList() {
    return Column(
      children: [
        for (int i = 0; i < skillList.length; i++) ...[
          if (i > 0)
            const Divider(
              height: 32,
              thickness: 1,
              color: Color.fromRGBO(216, 224, 167, 1.0),
            ),
          buildSkillExpansion(i),
        ],
      ],
    );
  }

  Widget buildSkillExpansion(int index) {
    final skill = skillList[index];
    return ExpansionWidget(
      initiallyExpanded: index == 0,
      titleBuilder: (double animationValue, _, bool isExpanded, toggle) {
        return InkWell(
          onTap: () => toggle(animated: true),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${skill.kategori ?? 'Kategori'} - ${skill.namaSkillController.text.isEmpty ? 'Nama Skill' : skill.namaSkillController.text}',
                        style: GoogleFonts.epilogue(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      if (skill.isExisting)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Saved',
                            style: GoogleFonts.epilogue(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Transform.rotate(
                  angle: math.pi * animationValue / 2,
                  child: const Icon(Icons.arrow_right, size: 30),
                ),
              ],
            ),
          ),
        );
      },
      content: Container(
        width: double.infinity,
        color: const Color.fromRGBO(250, 251, 247, 1.0),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel("Kategori Skill"),
            DropdownButtonFormField<String>(
              value: kategoriList.contains(skill.kategori) ? skill.kategori : null,
              items: kategoriList.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori, style: GoogleFonts.epilogue()),
                );
              }).toList(),
              onChanged: (value) => setState(() => skill.kategori = value),
              decoration: buildInputDecoration("Pilih kategori"),
            ),
            const SizedBox(height: 16),
            buildLabel("Nama Skill"),
            TextField(
              controller: skill.namaSkillController,
              decoration: buildInputDecoration("Masukkan nama skill"),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => saveSkillData(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8E0A7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  skill.isExisting ? 'Update' : 'Save',
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.epilogue(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.epilogue(
        fontSize: 13,
        color: const Color.fromRGBO(183, 183, 183, 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  void dispose() {
    for (var skill in skillList) {
      skill.dispose();
    }
    super.dispose();
  }
}

class SkillData {
  String? kategori;
  final TextEditingController namaSkillController = TextEditingController();
  bool isExisting = false;
  int? keahlianId;

  SkillData();

  SkillData.fromModel(SkillModel model) {
    namaSkillController.text = model.namaSkill ?? '';
    kategori = model.kategori ?? '';
    isExisting = true;
    keahlianId = model.keahlianId;
  }

  void dispose() {
    namaSkillController.dispose();
  }
}