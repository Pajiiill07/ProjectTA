class KontenModel {
  final int kontenId;
  final String? judul;
  final String? isi;
  final String? kategori;
  final String? sumber;

  KontenModel({
    required this.kontenId,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.sumber,
  });

  factory KontenModel.fromJson(Map<String, dynamic> json) {
    try {
      return KontenModel(
        kontenId: json["konten_id"] is int ? json["konten_id"] : int.parse(json["konten_id"].toString()),
        judul: json["judul"]?.toString() ?? "",
        isi: json["isi"]?.toString() ?? "",
        kategori: json["kategori"]?.toString() ?? "",
        sumber: json["sumber"]?.toString() ?? "",
      );
    } catch (e) {
      print("Error parsing KontenModel: $e");
      print("JSON data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    "konten_id": kontenId,
    "judul": judul,
    "isi": isi,
    "kategori": kategori,
    "sumber": kategori,
  };

  static KontenModel empty(int userId) {
    return KontenModel(
      kontenId: 0,
      judul: null,
      isi: null,
      kategori: null,
      sumber: null,
    );
  }
}