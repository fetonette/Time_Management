import 'dart:convert';
import 'package:myapp/features/Task/domain/entities/Task.dart';

class TaskModel extends Task{
  const TaskModel({
    required super. id,
    required super. title,
    required super. description,
    required super. deadline,
    required super. priority,
    required super. progress,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      deadline: DateTime.parse(map['deadline'] as String),
      priority: map['priority'] as int,
      progress: map['progress'] as double,
    );
  }

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'priority': priority,
      'progress': progress,
    };
  }

  String toJson() => json.encode(toMap());
}