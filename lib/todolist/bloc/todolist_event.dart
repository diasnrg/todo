import 'package:todo/models.dart';

abstract class TodoListEvent {}

class TodoListInitialized extends TodoListEvent {}

class TodoListItemCreated extends TodoListEvent {
  TodoListItemCreated(this.item);

  final Todo item;
}

class TodoListItemDeleted extends TodoListEvent {
  TodoListItemDeleted(this.item);

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
