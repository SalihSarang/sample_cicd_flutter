import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week_28/features/todo/domain/entities/todo.dart';
import 'package:week_28/features/todo/presentation/widgets/todo_card.dart';

void main() {
  testWidgets('TodoCard renders correctly and handles events', (
    WidgetTester tester,
  ) async {
    // arrange
    bool toggleCalled = false;
    bool deleteCalled = false;
    const todo = Todo(id: '1', title: 'Test Todo', isCompleted: false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TodoCard(
            todo: todo,
            onToggle: () => toggleCalled = true,
            onDelete: () => deleteCalled = true,
          ),
        ),
      ),
    );

    // assert
    expect(find.text('Test Todo'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    // act - toggle
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(toggleCalled, true);

    // act - delete
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();
    expect(deleteCalled, true);
  });
}
