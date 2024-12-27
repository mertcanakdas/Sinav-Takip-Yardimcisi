import 'package:flutter/material.dart';
import '../announcements_model.dart';
import 'announcement_item_view.dart';

class AnnouncementListView extends StatelessWidget {
  final List<Duyuru> announcements;

  const AnnouncementListView({Key? key, required this.announcements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        return AnnouncementItemView(announcement: announcements[index]);
      },
    );
  }
}
