import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/studysession.dart';
import '../repositories/studysession_repo.dart';

class UpdateStudySession {
  final StudySessionRepository repository;

  UpdateStudySession({required this.repository});

  Future<Either<Failure, void>> call(StudySession session) async {
    return await repository.updateStudySession(session);
  }
}
