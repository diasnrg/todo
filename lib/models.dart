import 'package:uuid/uuid.dart';

class Todo {
  Todo({
    String? id,
    required this.title,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v1();

  final String? id;
  final String title;
  final bool isCompleted;

  Todo copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
