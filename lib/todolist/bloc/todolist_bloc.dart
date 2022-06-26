import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/models.dart';
import 'package:todo/repository.dart';

part 'todolist_event.dart';
part 'todolist_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc({TodoRepository? repository})
      : _repository = repository ?? TodoRepository(),
        super(const TodoListState()) {
    on<TodoListInitialized>(_onTodoListInitialized);
    on<TodoListItemCreated>(_onItemCreated);
    on<TodoListItemRemoved>(_onItemRemoved);
    on<TodoListItemToggled>(_onItemToggled);
  }

  final TodoRepository _repository;

  Future<void> _onTodoListInitialized(
    TodoListInitialized event,
    Emitter<TodoListState> emit,
  ) async {
    emit(state.copyWith(status: TodoListStatus.loading));

    List<Todo> todos = [];
    try {
      todos = await _repository.getTodoList();
    } catch (e) {
      emit(state.copyWith(status: TodoListStatus.failure));
    }
    emit(state.copyWith(
      status: TodoListStatus.success,
      todos: todos,
    ));
  }

  Future<void> _onItemCreated(
    TodoListItemCreated event,
    Emitter<TodoListState> emit,
  ) async {
    try {
      await _repository.createTodoItem(event.item);

      emit(state.copyWith(
        todos: [...state.todos, event.item],
        status: TodoListStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: TodoListStatus.failure));
    }
  }

  Future<void> _onItemRemoved(
    TodoListItemRemoved event,
    Emitter<TodoListState> emit,
  ) async {
    try {
      await _repository.removeTodoItem(event.item);

      emit(state.copyWith(
        todos: state.todos..remove(event.item),
        status: TodoListStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: TodoListStatus.failure));
    }
  }

  Future<void> _onItemToggled(
    TodoListItemToggled event,
    Emitter<TodoListState> emit,
  ) async {
    final index = state.todos.indexWhere((item) => item.id == event.item.id);
    final updatedItem = event.item.copyWith(isCompleted: event.isCompleted);

    if (index == -1) {
      return;
    }

    try {
      await _repository.updateTodoItem(updatedItem);

      emit(state.copyWith(
        todos: state.todos..[index] = updatedItem,
        status: TodoListStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: TodoListStatus.failure));
    }
  }
}
