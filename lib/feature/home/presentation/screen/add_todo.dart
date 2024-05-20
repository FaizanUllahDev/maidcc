import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maidcc/core/color/app_colors.dart';
import 'package:maidcc/core/enums/enums.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/core/widgets/common_elevated_button.dart';
import 'package:maidcc/core/widgets/common_text_field_widget.dart';
import 'package:maidcc/core/widgets/gap.dart';
import 'package:maidcc/feature/home/data/model/todo_model.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_state.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({
    super.key,
    this.isEditing = false,
    this.model,
  });

  final TodoModel? model;
  final bool isEditing;

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isActive = false;

  @override
  void initState() {
    if (widget.isEditing) {
      controller.text = widget.model?.todo ?? '';
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TodoCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: CommonTextFieldWidget(
                hintText: 'Todo',
                maxLength: 100,
                controller: controller,
                suffixIcon: const Icon(Icons.task_alt_sharp),
                validation: (str) {
                  return str?.isEmpty == true ? 'Todo is required' : null;
                },
              ),
            ),
            const Gap(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                title: const Text('Completed'),
                trailing: StatefulBuilder(
                  builder: (ctx, setState) {
                    return Switch.adaptive(
                      activeColor: AppColors.primaryColor,
                      value: !widget.isEditing
                          ? isActive
                          : widget.model?.completed ?? false,
                      onChanged: (onChanged) {
                        if (!widget.isEditing) {
                          setState(() {
                            isActive = !isActive;
                          });
                        } else {
                          widget.model?.completed =
                              !(widget.model?.completed ?? false);
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ),
            const Gap(),
            BlocBuilder<TodoCubit, TodoState>(
              builder: (ctx, state) {
                if (state.status == StatusEnum.loading) {
                  return const CircularProgressIndicator();
                }
                return CommonElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      TodoModel newModel = TodoModel(
                        widget.model?.id ?? 0,
                        controller.text,
                        !widget.isEditing
                            ? isActive
                            : widget.model?.completed ?? false,
                        widget.model?.userId ?? Utils.currentUser.id ?? 0,
                      );
                      widget.isEditing
                          ? await cubit.updateTodo(newModel)
                          : await cubit.addTodo(newModel);
                      Navigator.pop(context);
                    }
                  },
                  title: widget.isEditing ? 'Update' : 'Add',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
