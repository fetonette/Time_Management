import 'package:myapp/features/Task/domain/entities/Task.dart';

abstract class TaskRemoteDataSource {
  Future<void> createTask(Task task);
  Future<List<Task>> getAllTasks(
      {DateTime? deadline, int? priority, String? subject});
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
