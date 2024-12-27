import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gunsayaci/components/widgets.dart';
import 'package:gunsayaci/exams/data/local/model/exam_model.dart';
import 'package:gunsayaci/utils/font_sizes.dart';
import 'package:gunsayaci/utils/util.dart';

import '../../../components/custom_app_bar.dart';
import '../../../utils/color_palette.dart';
import '../bloc/exam_bloc.dart';
import '../../../components/build_text_field.dart';

class NewExamScreen extends StatefulWidget {
  const NewExamScreen({super.key});

  @override
  State<NewExamScreen> createState() => _NewExamScreenState();
}

class _NewExamScreenState extends State<NewExamScreen> {
  TextEditingController examNameController = TextEditingController();
  TextEditingController correctCountController = TextEditingController();
  TextEditingController wrongCountController = TextEditingController();
  TextEditingController emptyCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<ExamBloc, ExamState>(
              listener: (context, state) {
                if (state is AddExamFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      getSnackBar(state.error, kRed));
                }
                if (state is AddExamSuccess) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return ListView(
                  children: [
                    const SizedBox(height: 20),
                    buildText(
                      'Sınav Adı',
                      kBlackColor,
                      textMedium,
                      FontWeight.bold,
                      TextAlign.start,
                      TextOverflow.clip,
                    ),
                    const SizedBox(height: 10),
                    BuildTextField(
                      hint: "Sınav Adını Giriniz",
                      controller: examNameController,
                      inputType: TextInputType.text,
                      fillColor: kWhiteColor,
                      onChange: (value) {},
                    ),
                    const SizedBox(height: 20),
                    buildText(
                      'Doğru Sayısı',
                      kBlackColor,
                      textMedium,
                      FontWeight.bold,
                      TextAlign.start,
                      TextOverflow.clip,
                    ),
                    const SizedBox(height: 10),
                    BuildTextField(
                      hint: "Doğru Sayısını Giriniz",
                      controller: correctCountController,
                      inputType: TextInputType.number,
                      fillColor: kWhiteColor,
                      onChange: (value) {},
                    ),
                    const SizedBox(height: 20),
                    buildText(
                      'Yanlış Sayısı',
                      kBlackColor,
                      textMedium,
                      FontWeight.bold,
                      TextAlign.start,
                      TextOverflow.clip,
                    ),
                    const SizedBox(height: 10),
                    BuildTextField(
                      hint: "Yanlış Sayısını Giriniz",
                      controller: wrongCountController,
                      inputType: TextInputType.number,
                      fillColor: kWhiteColor,
                      onChange: (value) {},
                    ),
                    const SizedBox(height: 20),
                    buildText(
                      'Boş Sayısı',
                      kBlackColor,
                      textMedium,
                      FontWeight.bold,
                      TextAlign.start,
                      TextOverflow.clip,
                    ),
                    const SizedBox(height: 10),
                    BuildTextField(
                      hint: "Boş Sayısını Giriniz",
                      controller: emptyCountController,
                      inputType: TextInputType.number,
                      fillColor: kWhiteColor,
                      onChange: (value) {},
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  kWhiteColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: buildText(
                                'İptal',
                                kBlackColor,
                                textMedium,
                                FontWeight.w600,
                                TextAlign.center,
                                TextOverflow.clip,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  kPrimaryColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              final String examId = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              var examModel = ExamModel(
                                id: examId,
                                examName: examNameController.text,
                                correctCount: int.tryParse(
                                    correctCountController.text) ??
                                    0,
                                wrongCount: int.tryParse(
                                    wrongCountController.text) ??
                                    0,
                                emptyCount: int.tryParse(
                                    emptyCountController.text) ??
                                    0,
                              );
                              context
                                  .read<ExamBloc>()
                                  .add(AddNewExamEvent(examModel: examModel));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: buildText(
                                'Kaydet',
                                kWhiteColor,
                                textMedium,
                                FontWeight.w600,
                                TextAlign.center,
                                TextOverflow.clip,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
