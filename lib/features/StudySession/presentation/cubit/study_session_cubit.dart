import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/studysession.dart';
import '../../domain/usecases/create_studysession.dart';
import '../../domain/usecases/delete_studysession.dart';
import '../../domain/usecases/read_studysession.dart';
import '../../domain/usecases/update_studysession.dart';

part 'study_session_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you're back online.";

class StudySessionCubit extends Cubit<StudySessionState> {
  final CreateStudysession _createStudysession;
  final DeleteStudySession _deleteStudySession;
  final GetStudySessions _getStudySessions;
  final UpdateStudySession _updateStudySession;

  StudySessionCubit({
    required CreateStudysession createStudysession,
    required DeleteStudySession deleteStudySession,
    required GetStudySessions getStudySessions,
    required UpdateStudySession updateStudySession,
  })  : _updateStudySession = updateStudySession,
        _getStudySessions = getStudySessions,
        _deleteStudySession = deleteStudySession,
        _createStudysession = createStudysession,
        super(StudySessionInitial());

  // Load StudySessions from the repository
  Future<void> fetchSessions({DateTime? date, String? subject}) async {
    emit(StudySessionLoading());

    try {
      final result = await _getStudySessions
          .call(date: date, subject: subject)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(StudySessionError(failure.getMessage())),
        (sessions) {
          emit(StudySessionLoaded(sessions));
        },
      );
    } on TimeoutException catch (_) {
      emit(const StudySessionError(
          "There seem to be a problem with your Internet Connection"));
    }
  }

  // Create a new StudySession
  Future<void> createSession(StudySession session) async {
    emit(StudySessionLoading());

    try {
      final result = await _createStudysession.call(session).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(StudySessionError(failure.getMessage())),
        (_) {
          emit(StudySessionAdded());
        },
      );
    } on TimeoutException catch (_) {
      emit(const StudySessionError("noInternetErrorMessage"));
    }
  }

  // Delete an existing StudySession by ID
  Future<void> deleteSession(String sessionId) async {
    emit(StudySessionLoading());

    try {
      final result = await _deleteStudySession.call(sessionId).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(StudySessionError(failure.getMessage())),
        (_) {
          emit(StudySessionDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(const StudySessionError("noInternetErrorMessage"));
    }
  }

  // Update an existing StudySession
  Future<void> updateSession(StudySession updatedSession) async {
    emit(StudySessionLoading());

    try {
      final result = await _updateStudySession.call(updatedSession).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));
      result.fold(
        (failure) => emit(StudySessionError(failure.getMessage())),
        (_) {
          emit(StudySessionUpdated(updatedSession));
        },
      );
    } on TimeoutException catch (_) {
      emit(const StudySessionError("noInternetErrorMessage"));
    }
  }
}
