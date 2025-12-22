import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:week_28/core/const/strings.dart';
import 'package:week_28/features/todo/domain/entities/todo.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_event.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_state.dart';
import 'package:week_28/features/todo/presentation/widgets/empty_todo_view.dart';
import 'package:week_28/features/todo/presentation/widgets/todo_card.dart';
import 'package:week_28/features/todo/presentation/widgets/todo_list.dart';

class MockTodoBloc extends MockBloc<TodoEvent, TodoState> implements TodoBloc {}

void main() {
  late MockTodoBloc mockTodoBloc;

  setUp(() {
    mockTodoBloc = MockTodoBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TodoBloc>.value(
          value: mockTodoBloc,
          child: const TodoList(),
        ),
      ),
    );
  }

  group('TodoList Widget', () {
    testWidgets('renders loading indicator when state is TodoLoading', (
      tester,
    ) async {
      when(() => mockTodoBloc.state).thenReturn(TodoLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'renders EmptyTodoView when state is TodoLoaded with empty list',
      (tester) async {
        when(() => mockTodoBloc.state).thenReturn(const TodoLoaded([]));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(EmptyTodoView), findsOneWidget);
        expect(find.text(AppStrings.noTodosYet), findsOneWidget);
      },
    );

    testWidgets(
      'renders list of TodoCards when state is TodoLoaded with todos',
      (tester) async {
        final todos = [
          const Todo(id: '1', title: 'Todo 1', isCompleted: false),
          const Todo(id: '2', title: 'Todo 2', isCompleted: true),
        ];
        when(() => mockTodoBloc.state).thenReturn(TodoLoaded(todos));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(TodoCard), findsNWidgets(2));
        expect(find.text('Todo 1'), findsOneWidget);
        expect(find.text('Todo 2'), findsOneWidget);
      },
    );

    testWidgets('renders error message when state is TodoError', (
      tester,
    ) async {
      const errorMessage = 'Something went wrong';
      when(() => mockTodoBloc.state).thenReturn(const TodoError(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining(errorMessage), findsOneWidget);
      expect(find.textContaining(AppStrings.error), findsOneWidget);
    });

    testWidgets(
      'renders initial empty view when state is TodoInitial (or default)',
      (tester) async {
        when(() => mockTodoBloc.state).thenReturn(TodoInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(EmptyTodoView), findsOneWidget);
        expect(find.text(AppStrings.addFirstTodo), findsOneWidget);
      },
    );
  });
}
