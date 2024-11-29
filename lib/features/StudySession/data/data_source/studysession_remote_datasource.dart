import '../../domain/entities/studysession.dart';

abstract class StudySessionRemoteDataSource{
Future<void> createStudySession(StudySession studySession);
Future<List<StudySession>> getStudySessions({DateTime? date, String? subject});
Future<void> updateStudySession(StudySession studySession);
Future<void> deleteStudySession(String studySessionId);
}
