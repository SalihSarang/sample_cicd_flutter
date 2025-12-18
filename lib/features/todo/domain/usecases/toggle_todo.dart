import 'package:week_28/features/todo/domain/entities/todo.dart';
import 'package:week_28/features/todo/domain/repositories/todo_repository.dart';

class ToggleTodo {
  final TodoRepository repository;

  ToggleTodo(this.repository);

  Future<void> call(Todo todo) async {
    return await repository.toggleTodo(todo);
  }
}
