import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maidcc/core/color/app_colors.dart';
import 'package:maidcc/core/router/routes.dart';
import 'package:maidcc/feature/home/data/model/todo_model.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_cubit.dart';

class ListBodyWidget extends StatelessWidget {
  const ListBodyWidget(this.todo, {super.key});

  final TodoModel todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            side: BorderSide(
              color: todo.completed ? Colors.green : Colors.grey,
              width: 1,
            ),
          ),
          title: Text(
            todo.todo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          leading: CircleAvatar(
            backgroundColor: todo.completed ? Colors.green : Colors.grey,
            child: Icon(
              todo.completed ? Icons.check : Icons.check_box_outline_blank,
              color: Colors.white,
            ),
          ),

          // subtitle: CommonChip(
          //   active: todo.completed,
          //   text: todo.completed ? 'Completed' : 'Pending',
          //   txtClr: Colors.white,
          // ),
          // contentPadding: EdgeInsets.zero,

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content: Text(
                              ' Todo: "${todo.todo}" \n\nAre you sure you want to delete this task?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                BlocProvider.of<TodoCubit>(context)
                                    .deleteTodo(todo.id);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {
                  AppRouter.push(AppRouter.editTodo,
                      extra: [BlocProvider.of<TodoCubit>(context), todo]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
