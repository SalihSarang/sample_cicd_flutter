import 'package:flutter_test/flutter_test.dart';
import 'package:week_28/features/todo/data/models/todo_model.dart';
import 'package:week_28/features/todo/domain/entities/todo.dart';

void main() {
  const tTodoModel = TodoModel(id: '1', title: 'Test Todo', isCompleted: false);

  test('should be a subclass of Todo entity', () async {
    expect(tTodoModel, isA<Todo>());
  });

  group('fromMap', () {
    test('should return a valid model when the map contains valid data', () {
      // arrange
      final map = {'title': 'Test Todo', 'isCompleted': false};
      // act
      final result = TodoModel.fromMap(map, '1');
      // assert
      expect(result, tTodoModel);
    });

    test(
      'should return a valid model with default values when map is incomplete',
      () {
        // arrange
        final map = <String, dynamic>{};
        // act
        final result = TodoModel.fromMap(map, '1');
        // assert
        expect(result.id, '1');
        expect(result.title, '');
        expect(result.isCompleted, false);
      },
    );
  });

  group('toMap', () {
    test('should return a JSON map containing the proper data', () {
      // act
      final result = tTodoModel.toMap();
      // assert
      final expectedMap = {'title': 'Test Todo', 'isCompleted': false};
      expect(result, expectedMap);
    });
  });

  group('copyWith', () {
    test('should return a valid model with updated values', () {
      // act
      final result = tTodoModel.copyWith(
        title: 'Updated Title',
        isCompleted: true,
      );
      // assert
      expect(result.title, 'Updated Title');
      expect(result.isCompleted, true);
      expect(result.id, tTodoModel.id);
    });
  });
}
