import '../models/task_model.dart';
import 'package:taskmanagement_app/services/shared_prefs_service.dart';

class LocalStorage {
  final SharedPrefsService _service = SharedPrefsService();

  Future<List<Task>> getTasks() async {
    return await _service.loadTasks();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _service.saveTasks(tasks);
  }
}
