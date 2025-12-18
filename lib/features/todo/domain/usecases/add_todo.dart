import 'package:week_28/features/todo/domain/repositories/todo_repository.dart';

class AddTodo {
  final TodoRepository repository;

  AddTodo(this.repository);

  Future<void> call(String title) async {
    return await repository.addTodo(title);
  }
}
