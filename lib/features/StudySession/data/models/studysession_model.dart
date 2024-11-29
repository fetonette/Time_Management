import 'dart:convert';
import 'package:myapp/features/StudySession/domain/entities/studysession.dart';

class StudySessionModel extends StudySession {
  const StudySessionModel({
    required super. id,
    required super. subject,
    required super. startTime,
    required super. duration,
    required super. goals,
  });

  factory StudySessionModel.fromMap(Map<String, dynamic> map) {
    return StudySessionModel(
      id: map['id'] as String,
      subject: map['subject'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      duration:  map['duration'] as int,
      goals: map['goals'] as String,
    );
  }

  factory StudySessionModel.fromJson(String source) =>
      StudySessionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'startTime': startTime.toIso8601String(),
      'duration': duration,
      'goals': goals,
    };
  }

  String toJson() => json.encode(toMap());
}
