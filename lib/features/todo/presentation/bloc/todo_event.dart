import 'package:equatable/equatable.dart';
import 'package:week_28/features/todo/domain/entities/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;
  const AddTodoEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class ToggleTodoEvent extends TodoEvent {
  final Todo todo;
  const ToggleTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  const DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateTodosList extends TodoEvent {
  final List<Todo> todos;
  const UpdateTodosList(this.todos);

  @override
  List<Object?> get props => [todos];
}
