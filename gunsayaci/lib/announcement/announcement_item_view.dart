import 'package:flutter/material.dart';
import 'package:gunsayaci/utils/color_palette.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import '../utils/color_palette.dart';
import 'announcement_view.dart';
import 'package:gunsayaci/announcements_model.dart';

class AnnouncementItemView extends StatelessWidget {
  final Duyuru announcement;

  const AnnouncementItemView({Key? key, required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String formattedDate = announcement.date != null
        ? DateFormat('dd.MM.yyyy').format(announcement.date!)  // Sayısal formatta tarih
        : '';

    return GestureDetector(
      onTap: () {
        // Tıklandığında yeni sayfaya yönlendirme
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnnouncementViewPage(announcement: announcement),
          ),
        );
      },
      child: Card(
        color: Color(0xffefefef),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              if (formattedDate.isNotEmpty)
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
