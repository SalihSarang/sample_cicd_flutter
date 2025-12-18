import 'package:flutter/material.dart';
import 'package:week_28/core/const/strings.dart';
import 'package:week_28/core/widgets/custom_app_bar.dart';
import 'package:week_28/features/home_screen/presentation/widgets/home_logout_button.dart';
import 'package:week_28/features/todo/presentation/widgets/add_todo_dialog.dart';
import 'package:week_28/features/todo/presentation/widgets/todo_list.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.appTitle,
        actions: [HomeLogoutButton()],
      ),
      body: const TodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTodoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
