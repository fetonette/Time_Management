import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import'../entities/studysession.dart';
import'../repositories/studysession_repo.dart';

class GetStudySessions{
  final StudySessionRepository repository;

  GetStudySessions({required this.repository});

  Future<Either<Failure, List<StudySession>>> call({DateTime? date, String? subject})async{
    return await repository.getStudySessions(date: date, subject: subject);
  }
}
