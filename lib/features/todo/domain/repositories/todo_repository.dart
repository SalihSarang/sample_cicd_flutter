import 'package:week_28/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Stream<List<Todo>> getTodos();
  Future<void> addTodo(String title);
  Future<void> toggleTodo(Todo todo);
  Future<void> deleteTodo(String id);
}
