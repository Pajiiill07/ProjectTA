class SkillModel {
  final int keahlianId;
  final int userId;
  final String? namaSkill;
  final String? kategori;

  SkillModel({
    required this.keahlianId,
    required this.userId,
    required this.namaSkill,
    required this.kategori,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    try {
      return SkillModel(
        keahlianId: json["keahlian_id"] is int ? json["keahlian_id"] : int.parse(json["keahlian_id"].toString()),
        userId: json["user_id"] is int ? json["user_id"] : int.parse(json["user_id"].toString()),
        namaSkill: json["nama_skill"]?.toString() ?? "",
        kategori: json["kategori"]?.toString() ?? "",
      );
    } catch (e) {
      print("Error parsing SkillModel: $e");
      print("JSON data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    "keahlian_id": keahlianId,
    "user_id": userId,
    "nama_skill": namaSkill,
    "kategori": kategori,
  };

  static SkillModel empty(int userId) {
    return SkillModel(
      keahlianId: 0,
      userId: userId,
      namaSkill: null,
      kategori: null,
    );
  }
}