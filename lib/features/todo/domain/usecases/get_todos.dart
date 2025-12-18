import 'package:week_28/features/todo/domain/entities/todo.dart';
import 'package:week_28/features/todo/domain/repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Stream<List<Todo>> call() {
    return repository.getTodos();
  }
}
