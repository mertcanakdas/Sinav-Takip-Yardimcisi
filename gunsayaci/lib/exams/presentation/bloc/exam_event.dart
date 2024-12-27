part of 'exam_bloc.dart';

abstract class ExamEvent {}

class AddNewExamEvent extends ExamEvent {
  final ExamModel examModel;

  AddNewExamEvent({required this.examModel});
}

class FetchExamEvent extends ExamEvent {}

class UpdateExamEvent extends ExamEvent {
  final ExamModel examModel;

  UpdateExamEvent({required this.examModel});
}

class DeleteExamEvent extends ExamEvent {
  final ExamModel examModel;

  DeleteExamEvent({required this.examModel});
}

class SearchExamEvent extends ExamEvent {
  final String keywords;

  SearchExamEvent({required this.keywords});
}
