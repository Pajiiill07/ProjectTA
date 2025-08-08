class ExperienceModel {
  final int pengalamanId;
  final int userId;
  final String? judul;
  final String? instansi;
  final DateTime? tanggalKegiatan;
  final String? keterangan;

  ExperienceModel({
    required this.pengalamanId,
    required this.userId,
    required this.judul,
    required this.instansi,
    required this.tanggalKegiatan,
    required this.keterangan,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    try {
      return ExperienceModel(
        pengalamanId: json["pengalaman_id"] is int ? json["pengalaman_id"] : int.parse(json["pengalaman_id"].toString()),
        userId: json["user_id"] is int ? json["user_id"] : int.parse(json["user_id"].toString()),
        judul: json["judul"]?.toString() ?? "",
        instansi: json["instansi"]?.toString() ?? "",
        tanggalKegiatan: json["tanggal_kegiatan"] != null ? DateTime.tryParse(json["tanggal_kegiatan"].toString()) : null,
        keterangan: json["keterangan"]?.toString() ?? "",
      );
    } catch (e) {
      print("Error parsing ExperienceModel: $e");
      print("JSON data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    "pengalaman_id": pengalamanId,
    "user_id": userId,
    "judul": judul,
    "instansi": instansi,
    "keterangan": keterangan,
    "tanggal_kegiatan": tanggalKegiatan?.toIso8601String(),
  };

  static ExperienceModel empty(int userId) {
    return ExperienceModel(
      pengalamanId: 0,
      userId: userId,
      judul: null,
      instansi: null,
      tanggalKegiatan: null,
      keterangan: null,
    );
  }
}