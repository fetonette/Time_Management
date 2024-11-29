import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/studysession.dart';
import '../repositories/studysession_repo.dart';

class CreateStudysession {
  final StudySessionRepository repository;

  CreateStudysession({required this.repository});

  Future<Either<Failure, void>> call(StudySession session) async {
   return repository.createStudySession(session);
  }
}
