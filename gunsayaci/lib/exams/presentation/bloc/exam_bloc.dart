import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local/model/exam_model.dart';
import '../../data/repository/exam_repository.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final ExamRepository examRepository;

  ExamBloc(this.examRepository) : super(FetchExamsSuccess(exams: const [])) {
    on<AddNewExamEvent>(_addNewExam);
    on<FetchExamEvent>(_fetchExams);
    on<UpdateExamEvent>(_updateExam);
    on<DeleteExamEvent>(_deleteExam);
    on<SearchExamEvent>(_searchExams);
  }

  _addNewExam(AddNewExamEvent event, Emitter<ExamState> emit) async {
    emit(ExamLoading());
    try {
      if (event.examModel.examName.trim().isEmpty) {
        return emit(AddExamFailure(error: 'Sınav adı boş olamaz'));
      }
      await examRepository.createNewExam(event.examModel);
      emit(AddExamSuccess());
      final exams = await examRepository.getExams();
      return emit(FetchExamsSuccess(exams: exams));
    } catch (exception) {
      emit(AddExamFailure(error: exception.toString()));
    }
  }

  void _fetchExams(FetchExamEvent event, Emitter<ExamState> emit) async {
    emit(ExamLoading());
    try {
      final exams = await examRepository.getExams();
      return emit(FetchExamsSuccess(exams: exams));
    } catch (exception) {
      emit(LoadExamFailure(error: exception.toString()));
    }
  }

  _updateExam(UpdateExamEvent event, Emitter<ExamState> emit) async {
    try {
      if (event.examModel.examName.trim().isEmpty) {
        return emit(UpdateExamFailure(error: 'Sınav adı boş olamaz'));
      }
      emit(ExamLoading());
      final exams = await examRepository.updateExam(event.examModel);
      emit(UpdateExamSuccess());
      return emit(FetchExamsSuccess(exams: exams));
    } catch (exception) {
      emit(UpdateExamFailure(error: exception.toString()));
    }
  }

  _deleteExam(DeleteExamEvent event, Emitter<ExamState> emit) async {
    emit(ExamLoading());
    try {
      final exams = await examRepository.deleteExam(event.examModel);
      return emit(FetchExamsSuccess(exams: exams));
    } catch (exception) {
      emit(LoadExamFailure(error: exception.toString()));
    }
  }

  _searchExams(SearchExamEvent event, Emitter<ExamState> emit) async {
    final exams = await examRepository.searchExams(event.keywords);
    return emit(FetchExamsSuccess(exams: exams, isSearching: true));
  }
}
