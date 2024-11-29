import 'package:equatable/equatable.dart';

class Task extends Equatable{
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final int priority;
  final double progress;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.progress,
  });

  @override
  List<Object?> get props => [id];

  }

