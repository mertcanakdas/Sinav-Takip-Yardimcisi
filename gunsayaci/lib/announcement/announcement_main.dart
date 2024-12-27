import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'announcement_service.dart';
import 'announcement_list_view.dart';
import '../announcements_model.dart';

class AnnouncementMainPage extends StatefulWidget {
  @override
  _AnnouncementMainPageState createState() => _AnnouncementMainPageState();
}

class _AnnouncementMainPageState extends State<AnnouncementMainPage> {
  late Future<List<Duyuru>> _futureDuyurular;

  @override
  void initState() {
    super.initState();
    // Duyuruları çekmek için servisi çağırıyoruz
    _futureDuyurular = DuyuruService().fetchDuyurular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xF7F2FA),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.black, fontSize: 35),
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_time_filled_sharp),
              title: Text('Sınav geri sayım'),
              onTap: () {
                Navigator.of(context).pushNamed("/"); // Geri sayım
              },
            ),
            ListTile(
              leading: Icon(Icons.add_chart_rounded),
              title: Text('Denemelerim'),
              onTap: () {
                Navigator.of(context).pushNamed("/exams"); // Denemeler
              },
            ),
            ListTile(
              leading: Icon(Icons.abc),
              title: Text('Notlarım'),
              onTap: () {
                Navigator.of(context).pushNamed("/tasks"); // Notlar
              },
            ),
            ListTile(
              leading: Icon(Icons.announcement_outlined),
              title: Text('Duyurular'),
              onTap: () {
                Navigator.of(context).pushNamed("/announcements"); // Duyurular
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/socials.png',
                width: 24.0,
                height: 24.0,
              ),
              title: Text('Sosyal Ağlar'),
              onTap: () {
                Navigator.of(context).pushNamed("/settings"); // Duyurular
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Duyuru>>(
        future: _futureDuyurular,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Bir hata oluştu: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Duyuru bulunamadı"));
          } else {
            return AnnouncementListView(announcements: snapshot.data!); // AnnouncementListView kullanılıyor
          }
        },
      ),
    );
  }
}
