import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gunsayaci/routes/pages.dart';
import '../../../components/widgets.dart';

import '../../../utils/color_palette.dart';
import '../../../utils/font_sizes.dart';
import '../../../utils/util.dart';
import '../../data/local/model/exam_model.dart';
import '../bloc/exam_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class ExamItemView extends StatefulWidget {
  final ExamModel examModel;

  const ExamItemView({super.key, required this.examModel});

  @override
  State<ExamItemView> createState() => _ExamItemViewState();
}

class _ExamItemViewState extends State<ExamItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: buildText(
                        widget.examModel.examName,
                        kBlackColor,
                        textMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip,
                      ),
                    ),
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
                             Navigator.of(context).pushNamed(Pages.updateExam,arguments: widget.examModel);


                              break;
                            }
                          case 1:
                            {
                              context.read<ExamBloc>().add(
                                  DeleteExamEvent(examModel: widget.examModel));
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
                                  TextOverflow.clip,
                                )
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
                                  TextOverflow.clip,
                                )
                              ],
                            ),
                          ),
                        ];
                      },
                      child: SvgPicture.asset('assets/svgs/vertical_menu.svg'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                buildText(
                  'Doğru Sayısı:' + widget.examModel.correctCount.toString(),
                  kGreen,
                  textSmall,
                  FontWeight.normal,
                  TextAlign.start,
                  TextOverflow.clip,
                ),
                buildText(
                  'Yanlış Sayısı:' + widget.examModel.wrongCount.toString(),
                  kRed,
                  textSmall,
                  FontWeight.normal,
                  TextAlign.start,
                  TextOverflow.clip,
                ),
                buildText(
                  'Boş Sayısı:' + widget.examModel.emptyCount.toString(),
                  kGrey0,
                  textSmall,
                  FontWeight.normal,
                  TextAlign.start,
                  TextOverflow.clip,
                ),
                buildText(
                  'Net Sayısı:' + widget.examModel.net.toStringAsFixed(2),
                  kPrimaryColor,
                  textSmall,
                  FontWeight.normal,
                  TextAlign.start,
                  TextOverflow.clip,
                ),
                const SizedBox(height: 10),

                // Donut Chart Widget
                SizedBox(
                  height: 200,
                  child: buildDonutChart(),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget buildDonutChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          widget.examModel.net.toStringAsFixed(2),
          style: const TextStyle(
            color: kPrimaryColor,
          ),
        ),
        PieChart(
          swapAnimationDuration: const Duration(microseconds: 750),
          swapAnimationCurve: Curves.easeInOutQuint,

          PieChartData(
            startDegreeOffset: 250,

            sections: [
              PieChartSectionData(
                value: widget.examModel.correctCount.toDouble(),
                color: kGreen,
                title: widget.examModel.correctCount.toDouble().toString(),
                titleStyle: const TextStyle(color: Colors.white),
              ),
              PieChartSectionData(
                value: widget.examModel.wrongCount.toDouble(),
                color: kRed,
                title: widget.examModel.wrongCount.toDouble().toString(),
                titleStyle: const TextStyle(color: Colors.white),
              ),
              PieChartSectionData(
                value: widget.examModel.emptyCount.toDouble(),
                color: kGrey0,
                title: widget.examModel.emptyCount.toDouble().toString(),
                titleStyle: const TextStyle(color: Colors.white),
              ),
            ],
            centerSpaceRadius: 50,
            // Ortada boşluk bırakır
            sectionsSpace: 0,

          ), // Bölümler arası boşluk
        ),
      ],
    );
  }
}
