import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/Task.dart' as myapptask;

abstract class TaskRepository {
  Future<Either<Failure, void>> createTask(myapptask.Task task);
  Future<Either<Failure, List<myapptask.Task>>> getAllTasks(
      {DateTime? deadline, int? priority, String? subject});
  Future<Either<Failure, void>> updateTask(myapptask.Task task); // Fixed: Added myapptask prefix
  Future<Either<Failure, void>> deleteTask(String taskId);
}
