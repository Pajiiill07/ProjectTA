class EducationModel {
  final int riwayatId;
  final int userId;
  final String? jenjang;
  final String? instansi;
  final String? jurusan;
  final DateTime? tahunMulai;
  final DateTime? tahunSelesai;

  EducationModel({
    required this.riwayatId,
    required this.userId,
    required this.jenjang,
    required this.instansi,
    required this.jurusan,
    required this.tahunMulai,
    this.tahunSelesai
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    try {
      return EducationModel(
        riwayatId: json["riwayat_id"] is int ? json["riwayat_id"] : int.parse(json["riwayat_id"].toString()),
        userId: json["user_id"] is int ? json["user_id"] : int.parse(json["user_id"].toString()),
        jenjang: json["jenjang"]?.toString() ?? "",
        instansi: json["instansi"]?.toString() ?? "",
        jurusan: json["jurusan"]?.toString() ?? "",
        tahunMulai: json["tahun_mulai"] != null ? DateTime.tryParse(json["tahun_mulai"].toString()) : null,
        tahunSelesai: json["tahun_selesai"] != null ? DateTime.tryParse(json["tahun_selesai"].toString()) : null,
      );
    } catch (e) {
      print("Error parsing EducationModel: $e");
      print("JSON data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    "riwayat_id": riwayatId,
    "user_id": userId,
    "jenjang": jenjang,
    "instansi": instansi,
    "jurusan": jurusan,
    "tahun_mulai": tahunMulai?.toIso8601String(),
    "tahun_selesai": tahunSelesai?.toIso8601String(),
  };

  static EducationModel empty(int userId) {
    return EducationModel(
      riwayatId: 0,
      userId: userId,
      jenjang: null,
      instansi: null,
      jurusan: null,
      tahunMulai: null,
      tahunSelesai: null,
    );
  }
}