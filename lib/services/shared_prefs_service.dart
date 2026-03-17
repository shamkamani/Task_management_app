import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanagement_app/data/models/task_model.dart';

class SharedPrefsService {
  static const String key = "tasks";

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = tasks.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, data);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];
    return data.map((e) => Task.fromJson(jsonDecode(e))).toList();
  }
}
