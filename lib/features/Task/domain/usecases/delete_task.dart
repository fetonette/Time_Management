import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/Task_repo.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask({required this.repository});

  Future<Either<Failure, void>> call(String taskId) async {
    // Call the repository method and return its result
    return await repository.deleteTask(taskId);
  }
}
