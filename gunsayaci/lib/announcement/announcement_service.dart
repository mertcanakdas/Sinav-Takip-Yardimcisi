import 'dart:convert';
import 'package:http/http.dart' as http;
import '../announcements_model.dart';

class DuyuruService {
  // PC'nin IP si girilmeli:5000/duyurular
  final String apiUrl = 'http://192.168.115.92:5000/duyurular';


  Future<List<Duyuru>> fetchDuyurular() async {
    try {

      final response = await http.get(Uri.parse(apiUrl));


      if (response.statusCode == 200) {

        String responseBody = utf8.decode(response.bodyBytes);


        List<dynamic> jsonData = json.decode(responseBody);


        List<Duyuru> duyurular = jsonData.map((item) => Duyuru.fromJson(item)).where((duyuru) => duyuru.title.isNotEmpty).toList();

        return duyurular;
      } else {

        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {

      throw Exception('Veriler alınamadı: ${e.toString()}');
    }
  }
}
