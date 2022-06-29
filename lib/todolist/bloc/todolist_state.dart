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

class TodoListState extends Equatable {
  const TodoListState({
    this.todolist = const [],
    this.status = TodoListStatus.initial,
    this.isHiddenCompletedItems = true,
  });

  final List<Todo> todolist;
  final TodoListStatus status;
  final bool isHiddenCompletedItems;

  TodoListState copyWith({
    List<Todo>? todolist,
    TodoListStatus? status,
    bool? isHiddenCompletedItems,
  }) {
    return TodoListState(
      todolist: todolist ?? this.todolist,
      status: status ?? this.status,
      isHiddenCompletedItems:
          isHiddenCompletedItems ?? this.isHiddenCompletedItems,
    );
  }

  @override
  List<Object> get props => [todolist, status, isHiddenCompletedItems];
}
