import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gunsayaci/components/custom_app_bar.dart';
import 'package:gunsayaci/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:gunsayaci/components/build_text_field.dart';
import 'package:gunsayaci/tasks/presentation/widget/task_item_view.dart';
import 'package:gunsayaci/utils/color_palette.dart';
import 'package:gunsayaci/utils/util.dart';

import '../../../components/widgets.dart';
import '../../../routes/pages.dart';
import '../../../utils/font_sizes.dart';
import '../../../widgets/global/action_icon_button.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<TasksBloc>().add(FetchTaskEvent());
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
          body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocConsumer<TasksBloc, TasksState>(
                      listener: (context, state) {
                    if (state is LoadTaskFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(getSnackBar(state.error, kRed));
                    }

                    if (state is AddTaskFailure || state is UpdateTaskFailure) {
                      context.read<TasksBloc>().add(FetchTaskEvent());
                    }
                  }, builder: (context, state) {
                    if (state is TasksLoading) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    if (state is LoadTaskFailure) {
                      return Center(
                        child: buildText(
                            state.error,
                            kBlackColor,
                            textMedium,
                            FontWeight.normal,
                            TextAlign.center,
                            TextOverflow.clip),
                      );
                    }

                    if (state is FetchTasksSuccess) {
                      return state.tasks.isNotEmpty || state.isSearching
                          ? Column(
                              children: [
                                BuildTextField(
                                    hint: "Notlarını Ara",
                                    controller: searchController,
                                    inputType: TextInputType.text,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: kGrey2,
                                    ),
                                    fillColor: kWhiteColor,
                                    onChange: (value) {
                                      context.read<TasksBloc>().add(
                                          SearchTaskEvent(keywords: value));
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                    child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: state.tasks.length,
                                  itemBuilder: (context, index) {
                                    return TaskItemView(
                                        taskModel: state.tasks[index]);
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider(
                                      color: kGrey3,
                                    );
                                  },
                                ))
                              ],
                            )
                          : Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/tasks.svg',
                                    height: size.height * .20,
                                    width: size.width,
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  buildText(
                                      'Ders Notlarınızı Kaydedin',
                                      kBlackColor,
                                      textBold,
                                      FontWeight.w600,
                                      TextAlign.center,
                                      TextOverflow.clip),
                                  buildText(
                                      '',
                                      kBlackColor.withOpacity(.5),
                                      textSmall,
                                      FontWeight.normal,
                                      TextAlign.center,
                                      TextOverflow.clip),
                                ],
                              ),
                            );
                    }
                    return Container();
                  }))),
          floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.add_circle,
                color: kPrimaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/NewTaskScreen");
              }),
        )));
  }
}
