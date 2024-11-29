part of 'study_session_cubit.dart';

abstract class StudySessionState extends Equatable {
  const StudySessionState();

  @override
  List<Object?> get props => [];
}

class StudySessionInitial extends StudySessionState {}

class StudySessionLoading extends StudySessionState {}

class StudySessionLoaded extends StudySessionState {
  final List<StudySession> sessions;

  const StudySessionLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class StudySessionAdded extends StudySessionState {}

class StudySessionDeleted extends StudySessionState {}

class StudySessionUpdated extends StudySessionState {
  final StudySession newStudySession;

  
   const StudySessionUpdated(this.newStudySession);

  @override
  List<Object?> get props => [newStudySession];
}

class StudySessionError extends StudySessionState {
  final String message;

  const StudySessionError(this.message);

  @override
  List<Object?> get props => [message];
}
