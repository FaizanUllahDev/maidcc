import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maidcc/core/color/app_colors.dart';
import 'package:maidcc/core/enums/enums.dart';
import 'package:maidcc/core/router/routes.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/core/widgets/common_chip.dart';
import 'package:maidcc/core/widgets/common_elevated_button.dart';
import 'package:maidcc/core/widgets/gap.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_state.dart';
import 'package:maidcc/feature/home/presentation/screen/list_body_widget.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        BlocProvider.of<TodoCubit>(context).getAllTodos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TodoCubit>();
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  AppRouter.push(AppRouter.addTodo, extra: [cubit]);
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        appBar: AppBar(
          title: const Text('Todo'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Utils.logout();
                AppRouter.pushUntil(AppRouter.root);
              },
            ),
          ],
        ),
        body: BlocConsumer<TodoCubit, TodoState>(listener: (ctx, state) {
          // if (state.status == StatusEnum.failed) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(state.message),
          //     ),
          //   );
          // }
        }, builder: (ctx, state) {
          if (state.status == StatusEnum.loading &&
              state.todoResponseModel.todos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == StatusEnum.failed &&
              state.todoResponseModel.todos.isEmpty) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(state.message),
                  const Gap(),
                  CommonElevatedButton(
                    title: 'Refresh',
                    onPressed: () {
                      cubit.getAllTodos(isFirsTimeCalling: true);
                    },
                  ),
                ],
              ),
            ));
          }

          if (state.status == StatusEnum.success &&
              state.todoResponseModel.todos.isEmpty) {
            return const Center(child: Text(' No Task'));
          }
          return ListView.separated(
            separatorBuilder: (ctx, index) {
              return const Divider();
            },
            itemCount: state.todoResponseModel.todos.length,
            itemBuilder: (ctx, index) {
              if (!cubit.willNotLoadMore &&
                  index == state.todoResponseModel.todos.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final todo = state.todoResponseModel.todos[index];
              return ListBodyWidget(todo);
            },
          );
        }),
      ),
    );
  }
}
