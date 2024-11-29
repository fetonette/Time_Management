import 'package:equatable/equatable.dart';

class StudySession extends Equatable {
  final String id;
  final String subject;
  final DateTime startTime;
  final int duration;
  final String goals;

  const StudySession({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.duration,
    required this.goals,
  });

  @override
  List<Object?> get props => [id];
}
