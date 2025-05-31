import 'package:hive/hive.dart';

part 'task.g.dart'; // This is important for Hive

@HiveType(typeId: 0) // Unique ID for Task objects in Hive
class Task extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  int priority; // 1: High, 2: Medium, 3: Low
  @HiveField(4)
  DateTime createdAt;
  @HiveField(5)
  DateTime taskTime; // This will represent the due date/time
  @HiveField(6)
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = 3, // Default to low priority
    required this.createdAt,
    required this.taskTime,
    this.isCompleted = false,
  });

  // Factory constructor for creating a Task from a map (e.g., from JSON/database) - Keep this
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: map['priority'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      taskTime: DateTime.parse(map['taskTime'] as String),
      isCompleted: map['isCompleted'] as bool,
    );
  }

  // Convert Task object to a map (e.g., for saving to JSON/database) - Keep this
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'taskTime': taskTime.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
