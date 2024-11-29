import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/Task.dart' as myapptask; 
import '../repositories/Task_repo.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask({required this.repository});

  Future<Either<Failure, void>> call(myapptask.Task task) async {
    return await repository.updateTask(task); 
  }
}
