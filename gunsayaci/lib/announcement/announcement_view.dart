import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../announcements_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AnnouncementViewPage extends StatefulWidget {
  final Duyuru announcement;

  const AnnouncementViewPage({Key? key, required this.announcement}) : super(key: key);

  @override
  _AnnouncementViewPageState createState() => _AnnouncementViewPageState();
}

class _AnnouncementViewPageState extends State<AnnouncementViewPage> {
  String announcementContent = '';  // İçeriği tutmak için bir değişken

  @override
  void initState() {
    super.initState();
    _fetchAnnouncementContent();
  }

  // URL'den duyuru içeriğini çeken fonksiyon
  Future<void> _fetchAnnouncementContent() async {
    try {
      final response = await http.get(Uri.parse(widget.announcement.link));

      if (response.statusCode == 200) {
        // HTML içeriğini parse et
        var document = parse(response.body);

        // İçeriği uygun HTML tag'leri ile çekmek
        var content = document.querySelector('div.content')?.outerHtml;

        setState(() {
          announcementContent = content ?? 'Duyuru içeriği bulunamadı';
        });
      } else {
        setState(() {
          announcementContent = 'Sunucu hatası: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        announcementContent = 'Veri çekme hatası: $e';
      });
    }
  }

  // URL açma fonksiyonu
  void _launchURL(String url) async {
    var uri = Uri.parse(url); // URL'yi URI'ye dönüştürün
    if (await canLaunchUrl(uri)) {  // URL'nin açılabilir olup olmadığını kontrol et
      await launchUrl(uri, mode: LaunchMode.externalApplication);  // URL'yi dış uygulamada aç
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('URL açılamadı: $url')),
      );
    }
  }

  // PDF dosyasını indirip açma fonksiyonu
  Future<void> _downloadAndOpenFile(String url) async {
    // URL'den dosyayı indir
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Cihazın geçici dizinine dosyayı kaydedin
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/file.pdf');

      await file.writeAsBytes(response.bodyBytes);  // Dosyayı kaydet

      // Dosyayı açmak için open_file kullanın
      OpenFile.open(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dosya indirilemedi: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // İçerik uzun olursa kaydırma için
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.announcement.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              if (widget.announcement.date != null)
                Text(
                  'Tarih: ${DateFormat('dd.MM.yyyy').format(widget.announcement.date!)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              SizedBox(height: 16.0),
              announcementContent.isEmpty
                  ? Center(child: CircularProgressIndicator())  // Veri çekilirken loading gösterebiliriz
                  : Html(
                data: announcementContent,
                onLinkTap: (url, _, __) {  // Parametreleri güncelledik
                  if (url != null) {
                    // PDF dosyası ise indirip açalım
                    if (url.endsWith('.pdf')) {
                      _downloadAndOpenFile(url);
                    } else {
                      _launchURL(url);  // Diğer bağlantılar için URL açalım
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
