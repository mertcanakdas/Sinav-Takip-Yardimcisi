import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/custom_app_bar.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/font_sizes.dart';
import '../../../components/build_text_field.dart';
import '../../../utils/util.dart';
import '../bloc/exam_bloc.dart';
import '../../data/local/model/exam_model.dart';

class UpdateExamScreen extends StatefulWidget {
  final ExamModel examModel;

  const UpdateExamScreen({super.key, required this.examModel});

  @override
  State<UpdateExamScreen> createState() => _UpdateExamScreenState();
}

class _UpdateExamScreenState extends State<UpdateExamScreen> {
  late TextEditingController examNameController;
  late TextEditingController correctCountController;
  late TextEditingController wrongCountController;
  late TextEditingController emptyCountController;

  @override
  void initState() {
    super.initState();
    examNameController = TextEditingController(text: widget.examModel.examName);
    correctCountController =
        TextEditingController(text: widget.examModel.correctCount.toString());
    wrongCountController =
        TextEditingController(text: widget.examModel.wrongCount.toString());
    emptyCountController =
        TextEditingController(text: widget.examModel.emptyCount.toString());
  }

  @override
  void dispose() {
    examNameController.dispose();
    correctCountController.dispose();
    wrongCountController.dispose();
    emptyCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kWhiteColor,
      appBar: const CustomAppBar(
        title: 'Güncelle',
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<ExamBloc,ExamState>(
            listener: (context, state) {
              if (state is UpdateExamFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                    getSnackBar(state.error, kRed));
              }
              if (state is UpdateExamSuccess) {
                Navigator.pop(context);
              }
            }, builder: (context,state) {
              return ListView(
                children: [
                  const Text(
                    "Sınav Adı",
                    style: TextStyle(
                      fontSize: textMedium, // Yazı boyutu
                      fontWeight: FontWeight.bold, // Yazı kalınlığı
                      color: Colors.black, // Yazı rengi
                    ),
                    textAlign: TextAlign.start, // Yazıyı sola hizalar
                    overflow: TextOverflow.ellipsis, // Uzun yazılar için taşmayı üç nokta ile gösterir
                  ),
                  const SizedBox(height: 10),
                  BuildTextField(
                    hint: "Sınav Adı",
                    controller: examNameController,
                    inputType: TextInputType.text,
                    onChange: (value) {},
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Doğru Sayısı",
                    style: TextStyle(
                      fontSize: textMedium, // Yazı boyutu
                      fontWeight: FontWeight.bold, // Yazı kalınlığı
                      color: Colors.black, // Yazı rengi
                    ),
                    textAlign: TextAlign.start, // Yazıyı sola hizalar
                    overflow: TextOverflow.ellipsis, // Uzun yazılar için taşmayı üç nokta ile gösterir
                  ),
                  const SizedBox(height: 10),
                  BuildTextField(
                    hint: "Doğru Sayısı",
                    controller: correctCountController,
                    inputType: TextInputType.number,
                    onChange: (value) {},
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Yanlış Sayısı",
                    style: TextStyle(
                      fontSize: textMedium, // Yazı boyutu
                      fontWeight: FontWeight.w600, // Yazı kalınlığı
                      color: kBlackColor, // Yazı rengi
                    ),
                    textAlign: TextAlign.start, // Yazıyı sola hizalar
                    overflow: TextOverflow.ellipsis, // Uzun yazılar için taşmayı üç nokta ile gösterir
                  ),
                  const SizedBox(height: 10),
                  BuildTextField(
                    hint: "Yanlış Sayısı",
                    controller: wrongCountController,
                    inputType: TextInputType.number,
                    onChange: (value) {},
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Boş Sayısı",
                    style: TextStyle(
                      fontSize: textMedium, // Yazı boyutu
                      fontWeight: FontWeight.bold, // Yazı kalınlığı
                      color: Colors.black, // Yazı rengi
                    ),
                    textAlign: TextAlign.start, // Yazıyı sola hizalar
                    overflow: TextOverflow.ellipsis, // Uzun yazılar için taşmayı üç nokta ile gösterir
                  ),
                  const SizedBox(height: 10),
                  BuildTextField(
                    hint: "Boş Sayısı",
                    controller: emptyCountController,
                    inputType: TextInputType.number,
                    onChange: (value) {},
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: size.width,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              kWhiteColor),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              kPrimaryColor),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the radius as needed
                            ),
                          ),
                        ),
                    onPressed: () {
                      final updatedExam = ExamModel(
                        id: widget.examModel.id,
                        examName: examNameController.text,
                        correctCount: int.parse(correctCountController.text),
                        wrongCount: int.parse(wrongCountController.text),
                        emptyCount: int.parse(emptyCountController.text),
                      );
                      context
                          .read<ExamBloc>()
                          .add(UpdateExamEvent(examModel: updatedExam));
                    },
                    child: const Text('Güncelle'),
                  )
                  )],
              );
          },

          )
    ),
      ),
    );
  }
}
