import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/models.dart';
import 'package:todo/repository.dart';

part 'todolist_event.dart';
part 'todolist_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc({required TodoRepository repository})
      : _repository = repository,
        super(const TodoListState()) {
    on<TodoListInitializationRequested>(_onInitializationRequested);
    on<TodoListItemCreated>(_onItemCreated);
    on<TodoListItemRemoved>(_onItemRemoved);
    on<TodoListItemToggled>(_onItemToggled);
  }

  final TodoRepository _repository;

  Future<void> _onInitializationRequested(
    TodoListInitializationRequested event,
    Emitter<TodoListState> emit,
  ) async {
    emit(state.copyWith(status: TodoListStatus.loading));

    // subscribing to the stream from repository to update the state for each update
    await emit.forEach<List<Todo>>(
      _repository.todolistStream,
      onData: (List<Todo> todolist) => state.copyWith(
        todos: todolist,
        status: TodoListStatus.success,
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: TodoListStatus.failure,
      ),
    );
  }

  Future<void> _onItemCreated(
    TodoListItemCreated event,
    Emitter<TodoListState> emit,
  ) async {
    await _repository.createTodoItem(event.item);
  }

  Future<void> _onItemRemoved(
    TodoListItemRemoved event,
    Emitter<TodoListState> emit,
  ) async {
    await _repository.removeTodoItem(event.item);
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

    return await _repository.updateTodoItem(updatedItem);
  }
}
