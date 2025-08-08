import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/experience_controller.dart';
import 'package:frontend_mobile/app/data/model/experience_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class ExperienceForm extends StatefulWidget {
  final VoidCallback onNext;

  const ExperienceForm({super.key, required this.onNext});

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  final ExperienceController experienceController =
      Get.find<ExperienceController>();

  List<ExperienceData> experienceList = [ExperienceData()];

  final List<String> yearList =
      List.generate(40, (index) => (1985 + index).toString());

  @override
  void initState() {
    super.initState();
    loadExistingExperienceData();
  }

  void loadExistingExperienceData() {
    final existingExperiences = experienceController.experienceList;
    if (existingExperiences.isNotEmpty) {
      setState(() {
        experienceList.clear();
        experienceList.addAll(existingExperiences
            .map((experience) => ExperienceData.fromModel(experience))
            .toList());
      });
    }
  }

  void addNewexperience() {
    setState(() {
      experienceList.add(ExperienceData());
    });
  }

  Future<void> saveExperienceData(int index) async {
    final experience = experienceList[index];

    if (experience.judulController.text.isEmpty ||
        experience.instansiController.text.isEmpty ||
        experience.selectedDate == null ||
        experience.keteranganController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field harus diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      if (experience.isExisting) {
        await experienceController.UpdateExperience(
          pengalamanId: experience.pengalamanId.toString(),
          judul: experience.judulController.text,
          instansi: experience.instansiController.text,
          tanggalKegiatan: experience.selectedDate!,
          keterangan: experience.keteranganController.text,
        );
        Get.snackbar(
          "Success",
          "Pengalaman berhasil diupdate",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        await experienceController.addExperience(
          judul: experience.judulController.text,
          instansi: experience.instansiController.text,
          tanggalKegiatan: experience.selectedDate!,
          keterangan: experience.keteranganController.text,
        );
        setState(() {
          experience.isExisting = true;
        });
        Get.snackbar(
          "Success",
          "Pengalaman  berhasil ditambahkan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      experienceController.refreshData();
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
          Text('Experience',
              style: GoogleFonts.epilogue(
                  fontSize: 22, fontWeight: FontWeight.w600)),
          Text(
            'Provide details of your experienceal background. Include degrees, institutions, and years of study',
            style: GoogleFonts.epilogue(
                fontSize: 13, color: const Color.fromRGBO(101, 101, 101, 1.0)),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (experienceController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return buildexperienceList();
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: addNewexperience,
              icon: const Icon(Icons.add, color: Color(0xFF7A8A3A)),
              label: Text(
                'Tambah Pengalaman',
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7A8A3A),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side:
                    const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
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

  Widget buildexperienceList() {
    return Column(
      children: [
        for (int i = 0; i < experienceList.length; i++) ...[
          if (i > 0)
            const Divider(
              height: 32,
              thickness: 1,
              color: Color.fromRGBO(216, 224, 167, 1.0),
            ),
          buildexperienceExpansion(i),
        ],
      ],
    );
  }

  Widget buildexperienceExpansion(int index) {
    final experience = experienceList[index];

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
                        '${experience.judulController.text.isEmpty ? 'Judul' : experience.judulController.text} '
                        '- (${experience.selectedDate ?? 'Tahun'})',
                        style:
                            GoogleFonts.epilogue(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      if (experience.isExisting)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
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
                )
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
            buildLabel("Judul"),
            TextField(
              controller: experience.judulController,
              decoration: buildInputDecoration("Enter your experience"),
            ),
            const SizedBox(height: 16),
            buildLabel("Instansi"),
            TextField(
              controller: experience.instansiController,
              decoration:
                  buildInputDecoration("Enter your experience institution"),
            ),
            const SizedBox(height: 16),
            buildLabel("Tanggal Kegiatan"),
            DropdownButtonFormField<String>(
              value: yearList.contains(experience.selectedDate)
                  ? experience.selectedDate
                  : null,
              items: yearList.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(year, style: GoogleFonts.epilogue()),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => experience.selectedDate = value),
              decoration: buildInputDecoration(""),
            ),
            const SizedBox(height: 16),
            buildLabel("Keterangan"),
            TextField(
              controller: experience.keteranganController,
              decoration: buildInputDecoration("Enter your description"),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => saveExperienceData(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8E0A7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  experience.isExisting ? 'Update' : 'Save',
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
          fontSize: 13, color: const Color.fromRGBO(183, 183, 183, 1.0)),
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
    for (var experience in experienceList) {
      experience.dispose();
    }
    super.dispose();
  }
}

class ExperienceData {
  String? selectedDate;
  final TextEditingController judulController = TextEditingController();
  final TextEditingController instansiController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  bool isExisting = false;
  int? pengalamanId;

  ExperienceData();

  ExperienceData.fromModel(ExperienceModel model) {
    selectedDate = model.tanggalKegiatan?.year.toString();
    judulController.text = model.judul ?? '';
    instansiController.text = model.instansi ?? '';
    keteranganController.text = model.keterangan ?? '';
    isExisting = true;
    pengalamanId = model.pengalamanId;
  }

  void dispose() {
    instansiController.dispose();
    judulController.dispose();
    keteranganController.dispose();
  }
}
