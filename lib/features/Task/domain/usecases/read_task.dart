import 'package:dartz/dartz.dart';
import 'package:myapp/features/Task/domain/repositories/Task_repo.dart';
import '../../../../core/errors/failure.dart';
import '../entities/Task.dart' as myapptask;

class GetTasks {
  final TaskRepository repository;

  GetTasks({required this.repository});

  Future<Either<Failure, List<myapptask.Task>>> call(
      {DateTime? deadline, int? priority, String? subject}) async {
    return await repository.getAllTasks(
        deadline: deadline, priority: priority, subject: subject);
  }
}
