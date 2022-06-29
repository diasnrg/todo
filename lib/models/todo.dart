import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Todo extends Equatable {
  Todo({
    String? id,
    required this.title,
    this.isCompleted = false,
    DateTime? lastUpdated,
  })  : id = id ?? const Uuid().v1(),
        lastUpdated = DateTime.now();

  final String id;
  final String title;
  final bool isCompleted;
  final DateTime lastUpdated;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Todo copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  @override
  List<Object> get props => [id, title, isCompleted, lastUpdated];
}
