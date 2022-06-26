import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/models/models.dart';
import 'package:todo/repository.dart';
import 'package:todo/todolist/bloc/todolist_bloc.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('TodoListBloc', () {
    late final MockTodoRepository repository;
    late final Todo item;

    setUpAll(() async {
      repository = MockTodoRepository();
      item = Todo(title: 'add test for bloc');

      when(() => repository.getTodoList()).thenAnswer((_) async => []);
      when(() => repository.createTodoItem(item)).thenAnswer((_) async => {});
      when(() => repository.updateTodoItem(item)).thenAnswer((_) async => {});
      when(() => repository.removeTodoItem(item)).thenAnswer((_) async => {});
    });

    blocTest(
      'initial state',
      build: () => TodoListBloc(repository: repository),
      act: (bloc) => bloc.add(TodoListInitialized()),
      expect: () => <TodoListState>[
        const TodoListState(todos: [], status: TodoListStatus.loading),
        const TodoListState(todos: [], status: TodoListStatus.success),
      ],
    );

    blocTest(
      'create todo item',
      build: () => TodoListBloc(repository: repository),
      act: (bloc) => bloc.add(TodoListItemCreated(item)),
      expect: () => <TodoListState>[
        TodoListState(todos: [item], status: TodoListStatus.success),
      ],
    );
  });
}
