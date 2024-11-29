import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import'../entities/studysession.dart';

abstract class StudySessionRepository{
  Future<Either<Failure, void>>createStudySession(StudySession session);
  Future<Either<Failure, List<StudySession>>> getStudySessions({DateTime? date, String? subject});
  Future<Either<Failure, void>> updateStudySession(StudySession session);
  Future<Either<Failure,void>> deleteStudySession(String sessionId);
}