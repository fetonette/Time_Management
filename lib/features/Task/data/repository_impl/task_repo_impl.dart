import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/Task/data/data_source/task_remote_datasource.dart';
import 'package:myapp/features/Task/domain/repositories/Task_repo.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/Task.dart' as myapptask;

class TaskRepositoryImplementation implements TaskRepository {
  final TaskRemoteDataSource _dataSource;

  const TaskRepositoryImplementation(this._dataSource);

  @override
  Future<Either<Failure, void>> createTask(myapptask.Task task) async {
    try {
      return Right(await _dataSource.createTask(task));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String TaskId) async {
    try {
      return Right(await _dataSource.deleteTask(TaskId));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<myapptask.Task>>> getAllTasks(
      {DateTime? deadline, int? priority, String? subject}) async {
    try {
      return Right(await _dataSource.getAllTasks(
          deadline: deadline, priority: priority, subject: subject));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(myapptask.Task task) async {
    try {
      return Right(await _dataSource.updateTask(task));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
