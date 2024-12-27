import 'package:gunsayaci/exams/data/local/data_sources/exam_data_provider.dart'; // ExamDataProvider yolunu güncelleyin
import 'package:gunsayaci/exams/data/local/model/exam_model.dart'; // ExamModel yolunu güncelleyin

class ExamRepository {
  final ExamDataProvider examDataProvider;

  ExamRepository({required this.examDataProvider});

  /// Tüm sınavları getir
  Future<List<ExamModel>> getExams() async {
    return await examDataProvider.getExams();
  }

  /// Yeni bir sınav oluştur
  Future<void> createNewExam(ExamModel examModel) async {
    return await examDataProvider.createExam(examModel);
  }

  /// Sınavı güncelle
  Future<List<ExamModel>> updateExam(ExamModel examModel) async {
    return await examDataProvider.updateExam(examModel);
  }

  /// Sınavı sil
  Future<List<ExamModel>> deleteExam(ExamModel examModel) async {
    return await examDataProvider.deleteExam(examModel);
  }

  /// Sınavlarda arama yap
  Future<List<ExamModel>> searchExams(String search) async {
    return await examDataProvider.searchExams(search);
  }
}
