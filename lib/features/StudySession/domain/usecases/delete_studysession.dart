import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/studysession_repo.dart';

class DeleteStudySession{
  final StudySessionRepository  repository;
  DeleteStudySession({required this.repository});

  Future<Either<Failure, void>>call(String sessionId)async{
    return repository.deleteStudySession(sessionId);

  }
}