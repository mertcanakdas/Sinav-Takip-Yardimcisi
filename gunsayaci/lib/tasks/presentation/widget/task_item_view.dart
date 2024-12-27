import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gunsayaci/routes/pages.dart';
import '../../../components/widgets.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_sizes.dart';
import '../../../utils/util.dart';
import '../../data/local/model/task_model.dart';
import '../bloc/tasks_bloc.dart';

class TaskItemView extends StatefulWidget {
  final TaskModel taskModel;
  const TaskItemView({super.key, required this.taskModel});

  @override
  State<TaskItemView> createState() => _TaskItemViewState();
}

class _TaskItemViewState extends State<TaskItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: buildText(
                          widget.taskModel.title,
                          kBlackColor,
                          textMedium,
                          FontWeight.w500,
                          TextAlign.start,
                          TextOverflow.clip)),
                      PopupMenuButton<int>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: kWhiteColor,
                        elevation: 1,
                        onSelected: (value) {
                          switch (value) {
                            case 0:
                              {
                                Navigator.pushNamed(context, Pages.updateTask, arguments: widget.taskModel);
                                break;
                              }
                            case 1:
                              {
                                context.read<TasksBloc>().add(
                                    DeleteTaskEvent(taskModel: widget.taskModel));
                                break;
                              }
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/edit.svg',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  buildText(
                                      'Güncelle',
                                      kBlackColor,
                                      textMedium,
                                      FontWeight.normal,
                                      TextAlign.start,
                                      TextOverflow.clip)
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/delete.svg',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  buildText(
                                      'Sil',
                                      kRed,
                                      textMedium,
                                      FontWeight.normal,
                                      TextAlign.start,
                                      TextOverflow.clip)
                                ],
                              ),
                            ),
                          ];
                        },
                        child: SvgPicture.asset('assets/svgs/vertical_menu.svg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  buildText(
                      widget.taskModel
                          .description,
                      kGrey1,
                      textSmall,
                      FontWeight.normal,
                      TextAlign.start,
                      TextOverflow.clip),
                  const SizedBox(height: 15,),

                ],
              ),
            ),
            const SizedBox(width: 10,),
          ],
        ));
  }
}
