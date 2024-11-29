import 'package:dartz/dartz.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/StudySession/data/data_source/studysession_remote_datasource.dart';
import 'package:myapp/features/StudySession/domain/entities/studysession.dart';
import 'package:myapp/features/StudySession/domain/repositories/studysession_repo.dart';
import '../../../../core/errors/failure.dart';

class StudySessionRepositoryImplementation implements StudySessionRepository {
  final StudySessionRemoteDataSource _dataSource;

  const StudySessionRepositoryImplementation(this._dataSource);

  @override
  Future<Either<Failure, void>> createStudySession(
      StudySession studySession) async {
    try {
      return Right(await _dataSource.createStudySession(studySession));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudySession(
      String studySessionId) async {
    try {
      return Right(await _dataSource.deleteStudySession(studySessionId));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudySession>>> getStudySessions(
      {DateTime? date, String? subject}) async {
    try {
      return Right(
          await _dataSource.getStudySessions(date: date, subject: subject));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateStudySession(
      StudySession studySession) async {
    try {
      return Right(await _dataSource.updateStudySession(studySession));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
