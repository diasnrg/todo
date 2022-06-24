part of 'todolist_bloc.dart';

abstract class TodoListEvent {}

class TodoListInitialized extends TodoListEvent {}

class TodoListItemCreated extends TodoListEvent {
  TodoListItemCreated(this.item);

  final Todo item;
}

class TodoListItemRemoved extends TodoListEvent {
  TodoListItemRemoved(this.item);

  final Todo item;
}

class TodoListItemToggled extends TodoListEvent {
  TodoListItemToggled(
    this.item,
    this.isCompleted,
  );

  final Todo item;
  final bool isCompleted;
}
