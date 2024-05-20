import 'package:maidcc/core/app_strings/app_strings.dart';
import 'package:maidcc/core/color/app_colors.dart';
import 'package:maidcc/feature/auth/presentation/cubit/login_state.dart';
import 'package:maidcc/core/enums/enums.dart';
import 'package:maidcc/core/router/routes.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/core/widgets/common_elevated_button.dart';
import 'package:maidcc/core/widgets/common_loader_widget.dart';
import 'package:maidcc/core/widgets/common_text_field_widget.dart';
import 'package:maidcc/core/widgets/gap.dart';
import 'package:maidcc/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.login,
                  style: TextStyle(
                    fontSize: 32,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(
                  value: 30,
                ),
                CommonTextFieldWidget(
                  hintText: AppStrings.username,
                  controller: usernameController,
                  validation: (txt) {
                    return txt!.isEmpty ? AppStrings.pleaseEnterText : null;
                  },
                ),
                const Gap(),
                CommonTextFieldWidget(
                  hintText: AppStrings.password,
                  controller: passwordController,
                  obscureText: true,
                  showStericPassword: true,
                  validation: (txt) {
                    return txt!.isEmpty ? AppStrings.pleaseEnterText : null;
                  },
                ),
                const Gap(),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (ctx, state) {
                    if (state.status == StatusEnum.failed) {
                      Utils.toast(ctx, state.message);
                    }

                    if (state.status == StatusEnum.success) {
                      AppRouter.pushUntil(AppRouter.homeScreen);
                    }
                  },
                  builder: (ctx, state) {
                    return state.status == StatusEnum.loading
                        ? const CommonLoaderWidget()
                        : CommonElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              context.read<LoginCubit>().login(
                                    usernameController.text,
                                    passwordController.text,
                                  );
                            },
                            title: AppStrings.login,
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
