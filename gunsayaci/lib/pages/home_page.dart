import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gunsayaci/locator.dart';
import 'package:gunsayaci/services/backend/database_service.dart';
import 'package:gunsayaci/services/models/data_model.dart';
import 'package:gunsayaci/services/providers/home_provider.dart';
import 'package:gunsayaci/utils/colors.dart';
import 'package:gunsayaci/widgets/features/home/countdown_widget.dart';
import 'package:gunsayaci/widgets/global/action_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/utils/utils.dart';

import '../utils/color_palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _dataFetch = false;

 
  @override
  void initState() {
    locator.get<DatabaseService>().getAllDatas().then((value) {
      setState(() => _dataFetch = true);
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataModelList = Provider.of<HomeProvider>(context).dataModelList;
    /*if (dataModelList.isEmpty && _dataFetch) _firstLoginNavigate();*/
    return Scaffold(
        appBar: AppBar(
          // Sol kısma Drawer menüsü ekleniyor
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(), // Drawer'ı aç
            ),
          ),
          backgroundColor: kWhiteColor,

          // title: const Text("app-name").tr(),
          actions: [
            ActionIconButton(
              iconData: Icons.add,
              onTap: () {
                Navigator.of(context).pushNamed(
                  "/create",
                  arguments: (isFirst: dataModelList.isEmpty, dataModel: null),
                );
              },
            ),

          ],
        ),
        drawer: Drawer(
          backgroundColor: kWhiteColor,
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
                  Navigator.of(context).pushNamed("/"); // geri sayım
                },
              ),
              ListTile(
                leading: Icon(Icons.add_chart_rounded),
                title: Text('Denemelerim'),
                onTap: () {
                  Navigator.of(context).pushNamed("/exams"); // Drawer'ı kapat
                },
              ),
              ListTile(
                leading: Icon(Icons.abc),
                title: Text('Notlarım'),
                onTap: () {
                  Navigator.of(context).pushNamed("/tasks"); // task e git
                },
              ), ListTile(
                leading: Icon(Icons.announcement_outlined),
                title: Text('Duyurular'),
                onTap: () {
                  Navigator.of(context).pushNamed("/announcements"); // Drawer'ı kapat
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

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: dataModelList.isEmpty
            ?  Align(
                alignment: Alignment.center,
                child: const Text("'+' ile yeni bir tane oluşturunuz",style: TextStyle(fontSize: 18),))

            : Stack(
                children: [
                  Container(height: 140 * dataModelList.length + 10),
                  ...List.generate(
                    dataModelList.length,
                    (index) {
                      final DataModel dataModel = dataModelList[index];
                      double top = 0;
                      if (index == 1) {
                        top = 40;
                      } else if (index == 2) {
                        top = 180;
                      } else if (index != 0) {
                        top = 140 * (index - 2) + 180;
                      }
                      return Positioned(
                        top: top,
                        left: 0,
                        right: 0,
                        child: CountdownWidget(
                          index: index,
                          dataModel: dataModel,
                        ),
                      );
                    },
                  ).toList().reversed,
                ],
              ),
      ),
    );
  }

}
