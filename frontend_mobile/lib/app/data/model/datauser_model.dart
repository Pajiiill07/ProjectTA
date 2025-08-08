class DataUserModel {
  final int dataId;
  final int userId;
  final String? namaLengkap;
  final String? noTelp;
  final String? linkedin;
  final String? alamat;
  final String? summary;

  DataUserModel({
    required this.dataId,
    required this.userId,
    required this.namaLengkap,
    required this.noTelp,
    required this.linkedin,
    required this.alamat,
    required this.summary,
  });

  factory DataUserModel.fromJson(Map<String, dynamic> json) {
    try {
      return DataUserModel(
        dataId: json["data_id"] is int ? json["data_id"] : int.parse(json["data_id"].toString()),
        userId: json["user_id"] is int ? json["user_id"] : int.parse(json["user_id"].toString()),
        namaLengkap: json["nama_lengkap"]?.toString() ?? "",
        noTelp: json["no_telp"]?.toString() ?? "",
        linkedin: json["linkedin"]?.toString() ?? "",
        alamat: json["alamat"]?.toString() ?? "",
        summary: json["summary"]?.toString() ?? "",
      );
    } catch (e) {
      print("Error parsing DataUserModel: $e");
      print("JSON data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    "data_id": dataId,
    "user_id": userId,
    "nama_lengkap": namaLengkap,
    "no_telp": noTelp,
    "linkedin": linkedin,
    "alamat": alamat,
    "summary": summary,
  };

  static DataUserModel empty(int userId) {
    return DataUserModel(
      dataId: 0,
      userId: userId,
      namaLengkap: null,
      noTelp: null,
      linkedin: null,
      alamat: null,
      summary: null,
    );
  }
}