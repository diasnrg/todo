import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todolist/bloc/todolist_event.dart';
import 'package:todo/todolist/bloc/todolist_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(const TodoListState()) {
    on<TodoListInitialized>(_onItemInitialized);
    on<TodoListItemCreated>(_onItemCreated);
    on<TodoListItemDeleted>(_onItemDeleted);
    on<TodoListItemToggled>(_onItemToggled);
  }

  void _onItemInitialized(TodoListInitialized event, Emitter<TodoListState> emit) {
    emit(state.copyWith(status: TodoListStatus.loading));
  }

  void _onItemCreated(TodoListItemCreated event, Emitter<TodoListState> emit) {
    emit(state.copyWith(
      todos: [...state.todos, event.item],
      status: TodoListStatus.success,
    ));
  }

  void _onItemDeleted(TodoListItemDeleted event, Emitter<TodoListState> emit) {
    emit(state.copyWith(
      todos: state.todos..remove(event.item),
      status: TodoListStatus.success,
    ));
  }

  void _onItemToggled(TodoListItemToggled event, Emitter<TodoListState> emit) {
    final index = state.todos.indexWhere((item) => item.id == event.item.id);
    final updatedItem = event.item.copyWith(isCompleted: event.isCompleted);

    emit(state.copyWith(todos: state.todos..[index] = updatedItem));
  }
}
