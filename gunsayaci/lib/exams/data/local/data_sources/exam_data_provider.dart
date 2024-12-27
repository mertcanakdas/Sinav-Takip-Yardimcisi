import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gunsayaci/exams/data/local/model/exam_model.dart'; // ExamModel sınıfının yolunu güncelleyin
import 'package:gunsayaci/utils/exception_handler.dart';

import '../../../../utils/constants.dart';

class ExamDataProvider {
  List<ExamModel> exams = [];
  SharedPreferences? prefs;

  ExamDataProvider(this.prefs);

  /// Sınavları getir
  Future<List<ExamModel>> getExams() async {
    try {
      final List<String>? savedExams = prefs!.getStringList(Constants.examKey);
      if (savedExams != null) {
        exams = savedExams
            .map((examJson) => ExamModel.fromJson(json.decode(examJson)))
            .toList();
      }
      return exams;
    } catch (e) {
      throw Exception(handleException(e));
    }
  }

  /// Yeni bir sınav ekle
  Future<void> createExam(ExamModel examModel) async {
    try {
      exams.add(examModel);
      final List<String> examJsonList =
      exams.map((exam) => json.encode(exam.toJson())).toList();
      await prefs!.setStringList(Constants.examKey, examJsonList);
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  /// Sınav güncelle
  Future<List<ExamModel>> updateExam(ExamModel examModel) async {
    try {
      exams[exams.indexWhere((element) => element.id == examModel.id)] =
          examModel;
      final List<String> examJsonList =
      exams.map((exam) => json.encode(exam.toJson())).toList();
      prefs!.setStringList(Constants.examKey, examJsonList);
      return exams;
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  /// Sınav sil
  Future<List<ExamModel>> deleteExam(ExamModel examModel) async {
    try {
      exams.remove(examModel);
      final List<String> examJsonList =
      exams.map((exam) => json.encode(exam.toJson())).toList();
      prefs!.setStringList(Constants.examKey, examJsonList);
      return exams;
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  /// Sınavlarda arama yap
  Future<List<ExamModel>> searchExams(String keywords) async {
    var searchText = keywords.toLowerCase();
    return exams.where((exam) {
      final nameMatches = exam.examName.toLowerCase().contains(searchText);
      return nameMatches;
    }).toList();
  }
}
