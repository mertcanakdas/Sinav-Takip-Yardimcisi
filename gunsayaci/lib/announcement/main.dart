import 'package:flutter/material.dart';


import 'announcement_main.dart';

void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duyurular Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnnouncementMainPage(),  // Ana sayfa olarak AnnouncementMainPage kullanılıyor
    );
  }
}
