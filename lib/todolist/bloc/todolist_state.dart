part of 'todolist_bloc.dart';

enum TodoListStatus {
  initial,
  loading,
  success,
  failure,
}

extension TodoListStatusX on TodoListStatus {
  bool get isInitial => this == TodoListStatus.initial;
  bool get isLoading => this == TodoListStatus.loading;
  bool get isSuccess => this == TodoListStatus.success;
  bool get isFailure => this == TodoListStatus.failure;
}

class TodoListState {
  const TodoListState({
    this.todos = const [],
    this.status = TodoListStatus.initial,
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
