import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/Task.dart' as myapptask;
import '../repositories/Task_repo.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask({required this.repository});

  Future<Either<Failure, void>> call(myapptask.Task task) async {
    return await repository.createTask(task);
  }
}
