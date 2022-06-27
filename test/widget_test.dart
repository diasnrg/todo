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

      when(() => repository.todolistStream)
          .thenAnswer((_) => Stream.value([item]));
      when(() => repository.createTodoItem(item)).thenAnswer((_) async => {});
      when(() => repository.updateTodoItem(item)).thenAnswer((_) async => {});
      when(() => repository.removeTodoItem(item)).thenAnswer((_) async => {});
    });

    blocTest(
      'initial state',
      build: () => TodoListBloc(repository: repository),
      act: (bloc) => bloc.add(TodoListInitializationRequested()),
      expect: () => <TodoListState>[
        const TodoListState(todos: [], status: TodoListStatus.loading),
        TodoListState(todos: [item], status: TodoListStatus.success),
      ],
    );

    group('CreateTodoItem', () {
      blocTest(
        'repository function call verification',
        build: () => TodoListBloc(repository: repository),
        seed: () => const TodoListState(status: TodoListStatus.loading),
        act: (bloc) => bloc.add(TodoListItemCreated(item)),
        verify: (_) {
          verify(() => repository.createTodoItem(item)).called(1);
        },
      );

      late final Todo item2;
      blocTest(
        'state changed',
        setUp: () {
          item2 = Todo(title: 'title for item2');
        },
        build: () => TodoListBloc(repository: repository)
          ..add(TodoListInitializationRequested()),
        seed: () => const TodoListState(status: TodoListStatus.loading),
        act: (bloc) => bloc.add(TodoListItemCreated(item2)),
        expect: () => <TodoListState>[
          TodoListState(todos: [item2], status: TodoListStatus.success),
        ],
      );
    });

    blocTest(
      'toggle todo item',
      build: () => TodoListBloc(repository: repository)
        ..add(TodoListInitializationRequested()),
      seed: () => const TodoListState(status: TodoListStatus.loading),
      act: (bloc) {
        bloc.add(TodoListItemToggled(item, true));
      },
      expect: () => [
        TodoListState(todos: [item], status: TodoListStatus.success),
        TodoListState(
            todos: [item.copyWith(isCompleted: true)],
            status: TodoListStatus.success),
      ],
    );
  });
}
