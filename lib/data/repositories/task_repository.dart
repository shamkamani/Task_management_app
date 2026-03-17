import 'package:taskmanagement_app/data/models/task_model.dart';
import 'package:taskmanagement_app/data/datasources/local_storage.dart';

class TaskRepository {
  final LocalStorage _localStorage = LocalStorage();

  Future<List<Task>> fetchTasks() async {
    return await _localStorage.getTasks();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _localStorage.saveTasks(tasks);
  }
}
