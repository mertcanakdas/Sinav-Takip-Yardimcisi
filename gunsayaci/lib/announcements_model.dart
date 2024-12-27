import 'package:intl/intl.dart';

class Duyuru {
  final String title;
  final String link;
  final DateTime? date;

  Duyuru({
    required this.title,
    required this.link,
    this.date,
  });

  // JSON'dan Duyuru modeline dönüştürme
  factory Duyuru.fromJson(Map<String, dynamic> json) {
    String title = json['title'];
    DateTime? date;

    // "bakım çalışması" başlıklarını filtreleme
    if (title.toLowerCase().contains("altyapı")) {
      return Duyuru(
        title: '',
        link: json['link'],
        date: null,
      );
    }

    // Başlık içerisindeki tarihi regex ile ayıklama
    final datePattern = RegExp(r'\((\d{2}\.\d{2}\.\d{4})\)');
    final match = datePattern.firstMatch(title);

    if (match != null) {
      // Tarihi başlıktan çıkarma
      String dateString = match.group(1) ?? '';
      try {
        // Tarihi DateTime formatına dönüştürme
        date = DateFormat('dd.MM.yyyy').parse(dateString);
        // Başlıktan tarihi çıkarma
        title = title.replaceAll('($dateString)', '').trim();
      } catch (e) {
        print("Tarih formatı hatalı: $e");
      }
    }

    return Duyuru(
      title: title,
      link: json['link'],
      date: date,
    );
  }
}
