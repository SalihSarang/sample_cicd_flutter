import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week_28/features/todo/domain/entities/todo.dart';
import 'package:week_28/features/todo/domain/usecases/add_todo.dart';
import 'package:week_28/features/todo/domain/usecases/delete_todo.dart';
import 'package:week_28/features/todo/domain/usecases/get_todos.dart';
import 'package:week_28/features/todo/domain/usecases/toggle_todo.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_event.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_state.dart';

class MockGetTodos extends Mock implements GetTodos {}

class MockAddTodo extends Mock implements AddTodo {}

class MockToggleTodo extends Mock implements ToggleTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

void main() {
  late TodoBloc todoBloc;
  late MockGetTodos mockGetTodos;
  late MockAddTodo mockAddTodo;
  late MockToggleTodo mockToggleTodo;
  late MockDeleteTodo mockDeleteTodo;

  setUpAll(() {
    registerFallbackValue(
      const Todo(id: '0', title: 'fallback', isCompleted: false),
    );
  });

  setUp(() {
    mockGetTodos = MockGetTodos();
    mockAddTodo = MockAddTodo();
    mockToggleTodo = MockToggleTodo();
    mockDeleteTodo = MockDeleteTodo();
    todoBloc = TodoBloc(
      getTodos: mockGetTodos,
      addTodo: mockAddTodo,
      toggleTodo: mockToggleTodo,
      deleteTodo: mockDeleteTodo,
    );
  });

  tearDown(() {
    todoBloc.close();
  });

  test('initial state should be TodoInitial', () {
    expect(todoBloc.state, isA<TodoInitial>());
  });

  const tTodo = Todo(id: '1', title: 'Test Todo', isCompleted: false);
  final tTodosList = [tTodo];

  group('LoadTodos', () {
    test(
      'should emit [TodoLoading, TodoError] when getting data fails',
      () async {
        // arrange
        when(() => mockGetTodos()).thenAnswer((_) => Stream.error('Error'));
        // act
        todoBloc.add(LoadTodos());
        // assert
        await expectLater(
          todoBloc.stream,
          emitsInOrder([isA<TodoLoading>(), isA<TodoError>()]),
        );
      },
    );

    test('should emit [TodoLoading] and then listen to stream', () async {
      // arrange
      when(() => mockGetTodos()).thenAnswer((_) => Stream.value(tTodosList));
      // act
      todoBloc.add(LoadTodos());
      // assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([isA<TodoLoading>(), TodoLoaded(tTodosList)]),
      );
    });
  });

  group('AddTodoEvent', () {
    blocTest<TodoBloc, TodoState>(
      'should call AddTodo usecase',
      build: () {
        when(() => mockAddTodo(any())).thenAnswer((_) async {});
        return todoBloc;
      },
      act: (bloc) => bloc.add(const AddTodoEvent('New Todo')),
      verify: (_) {
        verify(() => mockAddTodo('New Todo')).called(1);
      },
    );
  });

  group('ToggleTodoEvent', () {
    blocTest<TodoBloc, TodoState>(
      'should call ToggleTodo usecase',
      build: () {
        when(() => mockToggleTodo(any())).thenAnswer((_) async {});
        return todoBloc;
      },
      act: (bloc) => bloc.add(const ToggleTodoEvent(tTodo)),
      verify: (_) {
        verify(() => mockToggleTodo(tTodo)).called(1);
      },
    );
  });

  group('DeleteTodoEvent', () {
    blocTest<TodoBloc, TodoState>(
      'should call DeleteTodo usecase',
      build: () {
        when(() => mockDeleteTodo(any())).thenAnswer((_) async {});
        return todoBloc;
      },
      act: (bloc) => bloc.add(const DeleteTodoEvent('1')),
      verify: (_) {
        verify(() => mockDeleteTodo('1')).called(1);
      },
    );
  });
}
