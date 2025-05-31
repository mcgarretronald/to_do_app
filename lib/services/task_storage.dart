import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorage {
  static const String tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(tasksKey);

    if (jsonString == null) return [];

    final List<dynamic> taskList = json.decode(jsonString);
    return taskList.map((taskMap) => Task.fromMap(taskMap)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(tasks.map((t) => t.toMap()).toList());
    await prefs.setString(tasksKey, jsonString);
  }
}
