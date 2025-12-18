import 'package:week_28/features/todo/data/data_sources/todo_remote_data_source.dart';
import 'package:week_28/features/todo/data/models/todo_model.dart';
import 'package:week_28/features/todo/domain/entities/todo.dart';
import 'package:week_28/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Todo>> getTodos() {
    return remoteDataSource.getTodos();
  }

  @override
  Future<void> addTodo(String title) async {
    final todo = TodoModel(id: '', title: title, isCompleted: false);
    await remoteDataSource.addTodo(todo);
  }

  @override
  Future<void> toggleTodo(Todo todo) async {
    final todoModel = TodoModel(
      id: todo.id,
      title: todo.title,
      isCompleted: !todo.isCompleted,
    );
    await remoteDataSource.updateTodo(todoModel);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await remoteDataSource.deleteTodo(id);
  }
}
