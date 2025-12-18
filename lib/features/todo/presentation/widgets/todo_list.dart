import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:week_28/core/const/strings.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_event.dart';
import 'package:week_28/features/todo/presentation/bloc/todo_state.dart';
import 'package:week_28/features/todo/presentation/widgets/todo_card.dart';
import 'package:week_28/features/todo/presentation/widgets/empty_todo_view.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodoLoaded) {
          if (state.todos.isEmpty) {
            return const EmptyTodoView(message: AppStrings.noTodosYet);
          }
          return ListView.builder(
            itemCount: state.todos.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return TodoCard(
                todo: todo,
                onToggle: () {
                  context.read<TodoBloc>().add(ToggleTodoEvent(todo));
                },
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text(AppStrings.deleteTodo),
                      content: const Text(AppStrings.deleteConfirmation),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text(AppStrings.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<TodoBloc>().add(
                              DeleteTodoEvent(todo.id),
                            );
                            Navigator.pop(dialogContext);
                          },
                          child: const Text(
                            AppStrings.delete,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        } else if (state is TodoError) {
          return Center(child: Text('${AppStrings.error}: ${state.message}'));
        }
        return const EmptyTodoView(message: AppStrings.addFirstTodo);
      },
    );
  }
}
