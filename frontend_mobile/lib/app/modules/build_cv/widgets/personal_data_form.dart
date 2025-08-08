import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/datauser_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model untuk Province
class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}

// Model untuk Regency/City
class Regency {
  final String id;
  final String name;
  final String provinceId;

  Regency({required this.id, required this.name, required this.provinceId});

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      id: json['id'].toString(),
      name: json['name'],
      provinceId: json['province_id'].toString(),
    );
  }
}

class PersonalDataForm extends StatefulWidget {
  final VoidCallback onNext;

  const PersonalDataForm({super.key, required this.onNext});

  @override
  State<PersonalDataForm> createState() => _PersonalDataFormState();
}

class _PersonalDataFormState extends State<PersonalDataForm> {
  final dataUserController = Get.find<DataUserController>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController alamatDetailController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  // Address related variables
  List<Province> provinces = [];
  List<Regency> regencies = [];
  Province? selectedProvince;
  Regency? selectedRegency;
  bool isLoadingProvinces = false;
  bool isLoadingRegencies = false;

  @override
  void initState() {
    super.initState();
    loadProvinces();
    loadExistingData();
  }

  Future<void> loadProvinces() async {
    setState(() {
      isLoadingProvinces = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          provinces = data.map((json) => Province.fromJson(json)).toList();
        });
      } else {
        print('Failed to load provinces: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading provinces: $e');
      Get.snackbar(
        "Error",
        "Gagal memuat data provinsi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoadingProvinces = false;
      });
    }
  }

  Future<void> loadRegencies(String provinceId) async {
    setState(() {
      isLoadingRegencies = true;
      regencies.clear();
      selectedRegency = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          regencies = data.map((json) => Regency.fromJson(json)).toList();
        });
      } else {
        print('Failed to load regencies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading regencies: $e');
      Get.snackbar(
        "Error",
        "Gagal memuat data kota/kabupaten",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoadingRegencies = false;
      });
    }
  }

  void loadExistingData() {
    final userData = dataUserController.dataUser;
    if (userData != null && userData.dataId != null) {
      namaController.text = userData.namaLengkap ?? '';
      hpController.text = userData.noTelp ?? '';
      linkedinController.text = userData.linkedin ?? '';
      summaryController.text = userData.summary ?? '';

      // Parse existing address if available
      if (userData.alamat != null && userData.alamat!.isNotEmpty) {
        parseExistingAddress(userData.alamat!);
      }
    }
  }

  void parseExistingAddress(String fullAddress) {
    // Simple parsing - assume format: "Detail Address, City, Province"
    final parts = fullAddress.split(', ');
    if (parts.length >= 3) {
      alamatDetailController.text = parts[0];
      final cityName = parts[1];
      final provinceName = parts[2];

      // Try to find matching province and city
      final foundProvince = provinces.firstWhereOrNull(
              (p) => p.name.toLowerCase().contains(provinceName.toLowerCase())
      );

      if (foundProvince != null) {
        selectedProvince = foundProvince;
        loadRegencies(foundProvince.id).then((_) {
          final foundRegency = regencies.firstWhereOrNull(
                  (r) => r.name.toLowerCase().contains(cityName.toLowerCase())
          );
          if (foundRegency != null) {
            setState(() {
              selectedRegency = foundRegency;
            });
          }
        });
      }
    } else {
      // If parsing fails, put everything in detail address
      alamatDetailController.text = fullAddress;
    }
  }

  bool get hasExistingData {
    final userData = dataUserController.dataUser;
    return userData != null && userData.dataId != null;
  }

  String get fullAddress {
    List<String> addressParts = [];

    if (alamatDetailController.text.trim().isNotEmpty) {
      addressParts.add(alamatDetailController.text.trim());
    }

    if (selectedRegency != null) {
      addressParts.add(selectedRegency!.name);
    }

    if (selectedProvince != null) {
      addressParts.add(selectedProvince!.name);
    }

    return addressParts.join(', ');
  }

  void handleSave() async {
    // Validasi input
    if (namaController.text.trim().isEmpty ||
        hpController.text.trim().isEmpty ||
        fullAddress.isEmpty) {
      Get.snackbar(
        "Error",
        "Nama lengkap, nomor handphone, dan alamat harus diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final nama = namaController.text.trim();
    final hp = hpController.text.trim();
    final alamat = fullAddress;
    final linkedin = linkedinController.text.trim();
    final summary = summaryController.text.trim();

    try {
      if (hasExistingData) {
        // Update existing data
        print("Updating existing personal data");
        await dataUserController.updateDataUser(
          namaLengkap: nama,
          noHandphone: hp,
          alamat: alamat,
          linkedin: linkedin.isEmpty ? null : linkedin,
          summary: summary.isEmpty ? null : summary,
        );
      } else {
        // Add new data
        print("Adding new personal data");
        await dataUserController.addDataUser(
          namaLengkap: nama,
          noHandphone: hp,
          alamat: alamat,
          linkedin: linkedin,
          summary: summary,
        );
      }

      // Refresh data setelah save berhasil
      await dataUserController.refreshData();

    } catch (e) {
      print("Error saving personal data: $e");
      Get.snackbar(
        "Error",
        "Terjadi kesalahan saat menyimpan data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (dataUserController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText('Personal Data', 22, FontWeight.w600),
              buildText('Complete your personal data to make your cv even better', 13, FontWeight.normal,
                  color: const Color.fromRGBO(101, 101, 101, 1.0)),
              const SizedBox(height: 20),
              buildInputField('Nama Lengkap', namaController, 'Enter your full name'),
              buildInputField('No Handphone', hpController, 'Enter your phone number'),

              // Address Section
              buildAddressSection(),

              buildInputField('Linkedin', linkedinController, 'Enter your linkedin profile'),
              buildInputField('Summary', summaryController, 'Enter your summary', maxLines: 5),

              // Show full address preview
              if (fullAddress.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250, 251, 247, 1.0),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color.fromRGBO(216, 224, 167, 1.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText('Alamat Lengkap:', 12, FontWeight.w600,
                          color: const Color.fromRGBO(101, 101, 101, 1.0)),
                      const SizedBox(height: 4),
                      buildText(fullAddress, 14, FontWeight.normal),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(216, 224, 167, 1.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: handleSave,
                      child: Text(
                        hasExistingData ? 'Update' : 'Save',
                        style: GoogleFonts.epilogue(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(45, 43, 40, 1.0)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.onNext,
                      child: Text(
                        'Next',
                        style: GoogleFonts.epilogue(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7A8A3A),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText('Alamat', 14, FontWeight.w600),
          const SizedBox(height: 10),

          // Province Dropdown
          buildText('Provinsi', 12, FontWeight.w500, color: const Color.fromRGBO(101, 101, 101, 1.0)),
          const SizedBox(height: 5),
          DropdownButtonFormField<Province>(
            value: selectedProvince,
            isExpanded: true,
            decoration: buildInputDecoration("Pilih Provinsi"),
            items: isLoadingProvinces
                ? [
              DropdownMenuItem<Province>(
                value: null,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text('Loading...', style: GoogleFonts.epilogue()),
                  ],
                ),
              )
            ]
                : provinces.map((province) {
              return DropdownMenuItem<Province>(
                value: province,
                child: Text(province.name, style: GoogleFonts.epilogue()),
              );
            }).toList(),
            onChanged: isLoadingProvinces ? null : (Province? value) {
              setState(() {
                selectedProvince = value;
                selectedRegency = null;
                regencies.clear();
              });
              if (value != null) {
                loadRegencies(value.id);
              }
            },
          ),
          const SizedBox(height: 15),

          // Regency Dropdown
          buildText('Kota/Kabupaten', 12, FontWeight.w500, color: const Color.fromRGBO(101, 101, 101, 1.0)),
          const SizedBox(height: 5),
          DropdownButtonFormField<Regency>(
            value: selectedRegency,
            isExpanded: true,
            decoration: buildInputDecoration("Pilih Kota/Kabupaten"),
            items: isLoadingRegencies
                ? [
              DropdownMenuItem<Regency>(
                value: null,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text('Loading...', style: GoogleFonts.epilogue()),
                  ],
                ),
              )
            ]
                : regencies.map((regency) {
              return DropdownMenuItem<Regency>(
                value: regency,
                child: Text(regency.name, style: GoogleFonts.epilogue()),
              );
            }).toList(),
            onChanged: (selectedProvince == null || isLoadingRegencies) ? null : (Regency? value) {
              setState(() {
                selectedRegency = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildText(String text, double size, FontWeight weight, {Color? color}) {
    return Text(
      text,
      style: GoogleFonts.epilogue(
        fontSize: size,
        fontWeight: weight,
        color: color ?? Colors.black,
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildText(label, 14, FontWeight.w600),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: buildInputDecoration(hint),
        ),
      ]),
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
    namaController.dispose();
    hpController.dispose();
    alamatDetailController.dispose();
    linkedinController.dispose();
    summaryController.dispose();
    super.dispose();
  }
}