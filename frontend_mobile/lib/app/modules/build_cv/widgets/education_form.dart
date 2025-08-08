import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:frontend_mobile/app/data/controller/education_controller.dart';
import 'package:frontend_mobile/app/data/model/education_model.dart';

class EducationForm extends StatefulWidget {
  final VoidCallback onNext;

  const EducationForm({super.key, required this.onNext});

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final EducationController educationController = Get.find<EducationController>();

  List<EducationData> educationList = [EducationData()];

  final List<String> jenjangList = ['SLTA', 'D3', 'D4/S1', 'S2', 'S3'];
  final List<String> yearList = List.generate(40, (index) => (1985 + index).toString());

  @override
  void initState() {
    super.initState();
    loadExistingEducationData();
  }

  void loadExistingEducationData() {
    final existingEducations = educationController.educationList;
    if (existingEducations.isNotEmpty) {
      setState(() {
        educationList.clear();
        educationList.addAll(
            existingEducations.map((education) => EducationData.fromModel(education)).toList()
        );
      });
    }
  }

  void addNewEducation() {
    setState(() {
      educationList.add(EducationData());
    });
  }

  Future<void> saveEducationData(int index) async {
    final education = educationList[index];

    if (education.selectedJenjang == null ||
        education.instansiController.text.isEmpty ||
        education.jurusanController.text.isEmpty ||
        education.selectedStartYear == null ||
        education.selectedEndYear == null) {
      Get.snackbar(
        "Error",
        "Semua field harus diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      if (education.isExisting) {
        await educationController.UpdateEducation(
          riwayatId: education.riwayatId.toString(),
          jenjang: education.selectedJenjang!,
          instansi: education.instansiController.text,
          jurusan: education.jurusanController.text,
          tahunMulai: education.selectedStartYear!,
          tahunSelesai: education.selectedEndYear!,
        );
        Get.snackbar(
          "Success",
          "Riwayat Pendidikan ${index + 1} berhasil diupdate",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        await educationController.addEducation(
          jenjang: education.selectedJenjang!,
          instansi: education.instansiController.text,
          jurusan: education.jurusanController.text,
          tahunMulai: education.selectedStartYear!,
          tahunSelesai: education.selectedEndYear!,
        );
        setState(() {
          education.isExisting = true;
        });
        Get.snackbar(
          "Success",
          "Riwayat Pendidikan ${index + 1} berhasil ditambahkan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      educationController.refreshData();
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
          Text('Education',
              style: GoogleFonts.epilogue(fontSize: 22, fontWeight: FontWeight.w600)),
          Text(
            'Provide details of your educational background. Include degrees, institutions, and years of study',
            style: GoogleFonts.epilogue(fontSize: 13, color: const Color.fromRGBO(101, 101, 101, 1.0)),
          ),
          const SizedBox(height: 24),

          Obx(() {
            if (educationController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return buildEducationList();
          }),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: addNewEducation,
              icon: const Icon(Icons.add, color: Color(0xFF7A8A3A)),
              label: Text(
                'Tambah Riwayat Pendidikan',
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

  Widget buildEducationList() {
    return Column(
      children: [
        for (int i = 0; i < educationList.length; i++) ...[
          if (i > 0)
            const Divider(
              height: 32,
              thickness: 1,
              color: Color.fromRGBO(216, 224, 167, 1.0),
            ),
          buildEducationExpansion(i),
        ],
      ],
    );
  }

  Widget buildEducationExpansion(int index) {
    final education = educationList[index];

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
                        '${education.selectedJenjang ?? 'Jenjang'} - ${education.instansiController.text.isEmpty ? 'Instansi' : education.instansiController.text}',
                        style: GoogleFonts.epilogue(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      if (education.isExisting)
                        Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            buildLabel("Jenjang Pendidikan"),
            DropdownButtonFormField<String>(
              value: jenjangList.contains(education.selectedJenjang)
                  ? education.selectedJenjang
                  : null,
              items: jenjangList.map((jenjang) {
                return DropdownMenuItem(
                  value: jenjang,
                  child: Text(jenjang, style: GoogleFonts.epilogue()),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => education.selectedJenjang = value),
              decoration: buildInputDecoration("Pilih jenjang pendidikan"),
            ),
            const SizedBox(height: 16),

            buildLabel("Instansi"),
            TextField(
              controller: education.instansiController,
              decoration: buildInputDecoration("Enter your educational institution"),
            ),
            const SizedBox(height: 16),

            buildLabel("Jurusan"),
            TextField(
              controller: education.jurusanController,
              decoration: buildInputDecoration("Enter your major"),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel("Tahun Mulai"),
                      DropdownButtonFormField<String>(
                        value: yearList.contains(education.selectedStartYear)
                            ? education.selectedStartYear
                            : null,
                        items: yearList.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year, style: GoogleFonts.epilogue()),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => education.selectedStartYear = value),
                        decoration: buildInputDecoration(""),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.minimize_rounded),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel("Tahun Selesai"),
                      DropdownButtonFormField<String>(
                        value: yearList.contains(education.selectedEndYear)
                            ? education.selectedEndYear
                            : null,
                        items: yearList.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year, style: GoogleFonts.epilogue()),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => education.selectedEndYear = value),
                        decoration: buildInputDecoration(""),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => saveEducationData(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8E0A7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  education.isExisting ? 'Update' : 'Save',
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
    for (var education in educationList) {
      education.dispose();
    }
    super.dispose();
  }
}

class EducationData {
  String? selectedJenjang;
  String? selectedStartYear;
  String? selectedEndYear;
  final TextEditingController instansiController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();
  bool isExisting = false;
  int? riwayatId;

  EducationData();

  EducationData.fromModel(EducationModel model) {
    selectedJenjang = model.jenjang;
    selectedStartYear = model.tahunMulai?.year.toString();
    selectedEndYear = model.tahunSelesai?.year.toString();
    instansiController.text = model.instansi ?? '';
    jurusanController.text = model.jurusan ?? '';
    isExisting = true;
    riwayatId = model.riwayatId;
  }

  void dispose() {
    instansiController.dispose();
    jurusanController.dispose();
  }
}