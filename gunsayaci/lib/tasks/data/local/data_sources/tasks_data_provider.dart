import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gunsayaci/tasks/data/local/model/task_model.dart';
import 'package:gunsayaci/utils/exception_handler.dart';

import '../../../../utils/constants.dart';

class TaskDataProvider {
  List<TaskModel> tasks = [];
  SharedPreferences? prefs;

  TaskDataProvider(this.prefs);

  Future<List<TaskModel>> getTasks() async {
    try {
      final List<String>? savedTasks = prefs!.getStringList(Constants.taskKey);
      if (savedTasks != null) {
        tasks = savedTasks
            .map((taskJson) => TaskModel.fromJson(json.decode(taskJson)))
            .toList();
        tasks.sort((a, b) {
          if (a.completed == b.completed) {
            return 0;
          } else if (a.completed) {
            return 1;
          } else {
            return -1;
          }
        });
      }
      return tasks;
    }catch(e){
      throw Exception(handleException(e));
    }
  }

  Future<void> createTask(TaskModel taskModel) async {
    try {
      tasks.add(taskModel);
      final List<String> taskJsonList =
          tasks.map((task) => json.encode(task.toJson())).toList();
      await prefs!.setStringList(Constants.taskKey, taskJsonList);
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> updateTask(TaskModel taskModel) async {
    try {
      tasks[tasks.indexWhere((element) => element.id == taskModel.id)] =
          taskModel;
      tasks.sort((a, b) {
        if (a.completed == b.completed) {
          return 0;
        } else if (a.completed) {
          return 1;
        } else {
          return -1;
        }
      });
      final List<String> taskJsonList = tasks.map((task) =>
          json.encode(task.toJson())).toList();
      prefs!.setStringList(Constants.taskKey, taskJsonList);
      return tasks;
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> deleteTask(TaskModel taskModel) async {
    try {
      tasks.remove(taskModel);
      final List<String> taskJsonList = tasks.map((task) =>
          json.encode(task.toJson())).toList();
      prefs!.setStringList(Constants.taskKey, taskJsonList);
      return tasks;
    } catch (exception) {
      throw Exception(handleException(exception));
    }
  }

  Future<List<TaskModel>> searchTasks(String keywords) async {
    var searchText = keywords.toLowerCase();
    List<TaskModel> matchedTasked = tasks;
    return matchedTasked.where((task) {
      final titleMatches = task.title.toLowerCase().contains(searchText);
      final descriptionMatches = task.description.toLowerCase().contains(searchText);
      return titleMatches || descriptionMatches;
    }).toList();
  }
}
