part of 'exam_bloc.dart';

@immutable
sealed class ExamState {}

/// Sınavları başarıyla getirme durumu
final class FetchExamsSuccess extends ExamState {
  final List<ExamModel> exams;
  final bool isSearching;

  FetchExamsSuccess({required this.exams, this.isSearching = false});
}

/// Yeni sınav ekleme işlemi başarıyla tamamlandığında kullanılan durum
final class AddExamSuccess extends ExamState {}

/// Sınav yükleme işlemi sırasında bir hata oluştuğunda kullanılan durum
final class LoadExamFailure extends ExamState {
  final String error;

  LoadExamFailure({required this.error});
}

/// Yeni sınav ekleme işlemi sırasında bir hata oluştuğunda kullanılan durum
final class AddExamFailure extends ExamState {
  final String error;

  AddExamFailure({required this.error});
}

/// Yükleme durumunu temsil eder (örneğin, ağ isteği sırasında)
final class ExamLoading extends ExamState {}

/// Sınav güncelleme işlemi sırasında bir hata oluştuğunda kullanılan durum
final class UpdateExamFailure extends ExamState {
  final String error;

  UpdateExamFailure({required this.error});
}

/// Sınav güncelleme işlemi başarıyla tamamlandığında kullanılan durum
final class UpdateExamSuccess extends ExamState {}
