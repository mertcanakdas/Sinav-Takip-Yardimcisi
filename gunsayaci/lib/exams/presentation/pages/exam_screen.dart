import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gunsayaci/components/custom_app_bar.dart';
import 'package:gunsayaci/exams/presentation/bloc/exam_bloc.dart';
import 'package:gunsayaci/components/build_text_field.dart';
import 'package:gunsayaci/exams/presentation/widget/exam_item_view.dart';
import 'package:gunsayaci/utils/color_palette.dart';
import 'package:gunsayaci/utils/util.dart';

import '../../../components/widgets.dart';
import '../../../routes/pages.dart';
import '../../../utils/font_sizes.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<ExamBloc>().add(FetchExamEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: ScaffoldMessenger(
        child: Scaffold(
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
                    Navigator.pop(context); // Drawer'ı kapat
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
          backgroundColor: kWhiteColor,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocConsumer<ExamBloc, ExamState>(
                listener: (context, state) {
                  if (state is LoadExamFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(getSnackBar(state.error, kRed));
                  }

                  if (state is AddExamFailure || state is UpdateExamFailure) {
                    context.read<ExamBloc>().add(FetchExamEvent());
                  }
                },
                builder: (context, state) {
                  if (state is ExamLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  if (state is LoadExamFailure) {
                    return Center(
                      child: buildText(
                        state.error,
                        kBlackColor,
                        textMedium,
                        FontWeight.normal,
                        TextAlign.center,
                        TextOverflow.clip,
                      ),
                    );
                  }

                  if (state is FetchExamsSuccess) {
                    return state.exams.isNotEmpty || state.isSearching
                        ? Column(
                      children: [
                        BuildTextField(
                          hint: "Sınavları ara",
                          controller: searchController,
                          inputType: TextInputType.text,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: kGrey2,
                          ),
                          fillColor: kWhiteColor,
                          onChange: (value) {
                            context.read<ExamBloc>().add(
                                SearchExamEvent(keywords: value));
                          },
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.exams.length,
                            itemBuilder: (context, index) {

                              return ExamItemView(
                                  examModel: state.exams[index]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                color: kGrey2,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/exam.svg',
                            height: size.height * .20,
                            width: size.width,
                          ),
                          const SizedBox(height: 50),
                          buildText(
                            'Denemelerinizi Kaydedin',
                            kBlackColor,
                            textBold,
                            FontWeight.w600,
                            TextAlign.center,
                            TextOverflow.clip,
                          ),
                          buildText(
                            '',
                            kBlackColor.withOpacity(.5),
                            textSmall,
                            FontWeight.normal,
                            TextAlign.center,
                            TextOverflow.clip,
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add_circle,
              color: kPrimaryColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/NewExamScreen');
            },
          ),
        ),
      ),
    );
  }
}
