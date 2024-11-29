import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/errors/exceptions.dart';
import 'package:myapp/features/StudySession/data/data_source/studysession_remote_datasource.dart';
import 'package:myapp/features/StudySession/data/models/studysession_model.dart';
import 'package:myapp/features/StudySession/domain/entities/studysession.dart';

class StudySessionFirebaseRemoteDatasource
    implements StudySessionRemoteDataSource {
  final FirebaseFirestore _firestore;

  const StudySessionFirebaseRemoteDatasource(this._firestore);

  @override
  Future<void> createStudySession(StudySession studySession) async {
    try {
      final studySessionDocRef = _firestore.collection('studySessions').doc();
      final studysessionModel = StudySessionModel(
          id: studySessionDocRef.id,
          subject: studySession.subject,
          startTime: studySession.startTime,
          duration: studySession.duration,
          goals: studySession.goals);
      await studySessionDocRef.set(studysessionModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Something went wrong', statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deleteStudySession(String studySessionId) async {
    try {
      await _firestore.collection('studySessions').doc(studySessionId).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Something went wrong', statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<StudySession>> getStudySessions(
      {DateTime? date, String? subject}) async {
    try {
      Query query = _firestore.collection('studySessions');

      if (date != null) {
        // Firestore stores DateTime as a Timestamp, so convert to Timestamp for comparison
        final timestamp = Timestamp.fromDate(date);
        query = query.where('date', isEqualTo: timestamp);
      }

      if (subject != null) {
        query = query.where('subject', isEqualTo: subject);
      }

      final querySnapshot = await query.get();

      // Logging the number of documents fetched
      print('length: ${querySnapshot.docs.length}');

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return StudySession(
          id: doc.id,
          subject: data['subject'] ?? '',
          startTime: DateTime.parse(doc['startTime']),
          duration: data['duration'] ?? 0,
          goals: data['goals'] ?? '',
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Something went wrong', statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateStudySession(StudySession studySession) async {
    final studySessionModel = StudySessionModel(
        id: studySession.id,
        subject: studySession.subject,
        startTime: studySession.startTime,
        duration: studySession.duration,
        goals: studySession.goals);
    try {
      await _firestore
          .collection('studySessions')
          .doc(studySessionModel.id)
          .update(studySessionModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Something went wrong', statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
