import 'package:flutter/material.dart';
import 'package:gunsayaci/routes/pages.dart';
import 'package:gunsayaci/tasks/data/local/model/task_model.dart';
import 'package:gunsayaci/tasks/presentation/pages/new_task_screen.dart';
import 'package:gunsayaci/tasks/presentation/pages/tasks_screen.dart';
import 'package:gunsayaci/tasks/presentation/pages/update_task_screen.dart';
import 'package:gunsayaci/exams/presentation/pages/exam_screen.dart';
import 'package:gunsayaci/exams/presentation/pages/new_exam_screen.dart';
import 'package:gunsayaci/exams/presentation/pages/update_exam_screen.dart';

import '../exams/data/local/model/exam_model.dart';
import '../page_not_found.dart';

Route onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Pages.home:
      return MaterialPageRoute(
        builder: (context) => const TasksScreen(),
      );
    case Pages.createNewTask:
      return MaterialPageRoute(
        builder: (context) => const NewTaskScreen(),
      );
    case Pages.updateTask:
      final args = routeSettings.arguments as TaskModel;
      return MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(taskModel: args),
      );
    case Pages.exam:
      return MaterialPageRoute(
        builder: (context) => const ExamScreen(),
      );
    case Pages.createNewExam:
      return MaterialPageRoute(
        builder: (context) => const NewExamScreen(),
      );
    case Pages.updateExam:
      final args = routeSettings.arguments as ExamModel;
      return MaterialPageRoute(
        builder: (context) => UpdateExamScreen(examModel: args,),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const PageNotFound(),
      );
  }
}
