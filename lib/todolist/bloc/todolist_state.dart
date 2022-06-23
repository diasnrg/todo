import 'package:todo/models.dart';

enum TodoListStatus {
  initialized,
  loading,
  success,
  failure,
}

class TodoListState {
  const TodoListState({
    this.todos = const [],
    this.status = TodoListStatus.initialized,
  });

  final List<Todo> todos;
  final TodoListStatus status;

  TodoListState copyWith({
    List<Todo>? todos,
    TodoListStatus? status,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }
}
