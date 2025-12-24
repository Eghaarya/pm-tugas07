// ==================== lib/models/kegiatan_model.dart ====================
class KegiatanModel {
  final int? id;
  final String namaKegiatan;
  final String? deskripsi;
  final String tanggal;
  final String? createdAt;
  final String? updatedAt;

  KegiatanModel({
    this.id,
    required this.namaKegiatan,
    this.deskripsi,
    required this.tanggal,
    this.createdAt,
    this.updatedAt,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      namaKegiatan: json['nama_kegiatan'] ?? '',
      deskripsi: json['deskripsi'],
      tanggal: json['tanggal'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_kegiatan': namaKegiatan,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
    };
  }
}
