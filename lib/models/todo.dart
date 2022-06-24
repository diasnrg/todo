import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Todo {
  Todo({
    String? id,
    required this.title,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v1();

  final String? id;
  final String title;
  final bool isCompleted;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

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

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
