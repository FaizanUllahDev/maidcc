import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/di/injection_container.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:maidcc/feature/auth/presentation/screen/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:maidcc/feature/home/presentation/screen/add_todo.dart';
import 'package:maidcc/feature/home/presentation/screen/todo_screen.dart';

class AppRouter {
  // all the route paths. So that we can access them easily  across the app
  static const root = '/';
  static const homeScreen = '/homeScreen';
  static const addTodo = '/addTodo';
  static const editTodo = '/editTodo';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  // ========================================================     NAVIGATOR HELPERS

  // push
  static Future<void> push(String path,
      {dynamic extra, BuildContext? context}) async {
    if (path == currentLocation()) return;
    await GoRouter.of(context ?? _rootNavigatorKey.currentContext!).push(
      path,
      extra: extra,
    );
  }

  // until
  static Future<void> pushUntil(String path, {dynamic extra}) async {
    GoRouter.of(_rootNavigatorKey.currentContext!).pushReplacement(
      path,
      extra: extra,
    );
  }

  //  pop
  static void pop() {
    GoRouter.of(_rootNavigatorKey.currentContext!).pop();
  }

  // context

  // ========================================================     GETTERS

  static BuildContext get context => _rootNavigatorKey.currentContext!;

  static GoRouter get router => _router;

  //get root navigator key
  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  // ======================================================== ROUTES

  /// use this in [MaterialApp.router]
  static final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      /// ==========================================  ROLE BASED PAGES  ========================================
      // root

      GoRoute(
        path: root,
        builder: (context, state) {
          return BlocProvider(
            create: (ctx) => sl<LoginCubit>(),
            child: const LoginScreen(),
          );
        },
      ),
      GoRoute(
        path: homeScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (ctx) =>
                sl<TodoCubit>()..getAllTodos(isFirsTimeCalling: true),
            child: const TodoScreen(),
          );
        },
      ),
      GoRoute(
        path: addTodo,
        builder: (context, state) {
          final list = (state.extra as List);
          return BlocProvider.value(
            value: list.first as TodoCubit,
            child: const AddTodoScreen(),
          );
        },
      ),
      GoRoute(
        path: editTodo,
        builder: (context, state) {
          final list = (state.extra as List);
          return BlocProvider.value(
            value: list.first as TodoCubit,
            child: AddTodoScreen(model: list.last, isEditing: true),
          );
        },
      ),
    ],
    initialLocation: Utils.isUserLogin ? homeScreen : root,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
  );

  /// returns the current route location
  static String currentLocation() {
    final RouteMatch lastMatch =
        GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : GoRouter.of(context).routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      Container();
}
