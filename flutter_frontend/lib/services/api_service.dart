// ==================== lib/services/api_service.dart ====================
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kegiatan_model.dart';

class ApiService {
  static const String baseUrl =
      'https://macrocytic-izayah-unpummeled.ngrok-free.dev/api/kegiatan';

  Future<List<KegiatanModel>> getKegiatan() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => KegiatanModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> addKegiatan(KegiatanModel kegiatan) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(kegiatan.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Gagal menambahkan data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
