import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week_28/features/todo/domain/usecases/add_todo.dart';
import 'package:week_28/features/todo/domain/usecases/delete_todo.dart';
import 'package:week_28/features/todo/domain/usecases/get_todos.dart';
import 'package:week_28/features/todo/domain/usecases/toggle_todo.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_event.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final ToggleTodo toggleTodo;
  final DeleteTodo deleteTodo;

  StreamSubscription? _todosSubscription;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.toggleTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<UpdateTodosList>(_onUpdateTodosList);
    on<AddTodoEvent>(_onAddTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) {
    emit(TodoLoading());
    _todosSubscription?.cancel();
    _todosSubscription = getTodos().listen(
      (todos) => add(UpdateTodosList(todos)),
      onError: (error) => emit(TodoError(error.toString())),
    );
  }

  void _onUpdateTodosList(UpdateTodosList event, Emitter<TodoState> emit) {
    emit(TodoLoaded(event.todos));
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await addTodo(event.title);
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onToggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await toggleTodo(event.todo);
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await deleteTodo(event.id);
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}
