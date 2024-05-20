import 'package:maidcc/core/constants.dart';
import 'package:maidcc/core/cubit/base_cubit.dart';
import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/di/injection_container.dart';
import 'package:maidcc/core/enums/enums.dart';
import 'package:maidcc/core/network/network_exceptions.dart';
import 'package:maidcc/core/network/network_info.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/feature/home/data/model/todo_model.dart';
import 'package:maidcc/feature/home/data/model/todo_model_response_model.dart';
import 'package:maidcc/feature/home/data/model/todo_request_model.dart';
import 'package:maidcc/feature/home/domain/todo_repository.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_state.dart';

class TodoCubit extends BaseCubit<TodoState> {
  TodoCubit(this.repository, this.networkInfo, this.preferencesUtil)
      : super(TodoState()) {
    // getAllTodos(isFirsTimeCalling: true);
  }

  final TodoRepository repository;

  final NetworkInfo networkInfo;

  final PreferencesUtil preferencesUtil;

  int skip = 0;
  int limit = 10;
  bool isLoadMore = false;

  bool get willNotLoadMore =>
      state.todoResponseModel.todos.length >= state.todoResponseModel.total;

  Future<void> getAllTodos({bool isFirsTimeCalling = false}) async {
    if (!isFirsTimeCalling) {
      if (willNotLoadMore) {
        return;
      }
    }
    try {
      emitLoading();
      if (!(await networkInfo.isConnected)) {
        final data = preferencesUtil.getPreferencesData(
          AppKeyConstants.todosData,
        );
        if (data != null && data.toString() != "") {
          Utils.debug((data is String).toString());
          final mapData = TodoResponseModel.fromJson(data);
          emit(
            state.copyWith(
              todoResponseModel: mapData,
              status: StatusEnum.success,
            ),
          );
          emitSuccess();

          return;
        }
      }
      final response = await repository.getTodos(
        TodoRequestModel(
          skip: skip,
          limit: limit,
        ),
      );

      List<TodoModel> oldData = [...state.todoResponseModel.todos];
      if (isFirsTimeCalling) {
        oldData = [];
      }

      oldData.addAll(response.todos);

      skip = response.skip;

      final newData = TodoResponseModel(
        todos: oldData,
        total: response.total,
        skip: response.skip,
        limit: response.limit,
      );

      setListData();

      emit(state.copyWith(
        todoResponseModel: newData,
        status: StatusEnum.success,
      ));
    } on MyException catch (e) {
      emitError(message: e.message);
    } catch (e) {
      emitError(message: e.toString());
    }
  }

  Future<void> addTodo(TodoModel model) async {
    try {
      emit(
        state.copyWith(
          todoResponseModel: state.todoResponseModel.copyWith(
            todos: [...state.todoResponseModel.todos, model],
          ),
        ),
      );
      setListData();

      await repository.addTodo(model);

      emitSuccess();
    } on MyException catch (e) {
      emitError(message: e.message);
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final oldData = [...state.todoResponseModel.todos];
      oldData.removeWhere((element) => element.id == id);
      emit(
        state.copyWith(
          todoResponseModel: state.todoResponseModel.copyWith(
            todos: oldData,
          ),
        ),
      );
      setListData();

      emitLoading();
      await repository.deleteTodo(id);
      emitSuccess();
      // await getAllTodos(isFirsTimeCalling: true);
    } on MyException catch (e) {
      emitError(message: e.message);
    } catch (e) {
      emitError(message: e.toString());
    }
  }

  Future<void> updateTodo(TodoModel model) async {
    try {
      emit(
        state.copyWith(
          todoResponseModel: state.todoResponseModel.copyWith(
            todos: state.todoResponseModel.todos.map((element) {
              if (element.id == model.id) {
                return model;
              }
              return element;
            }).toList(),
          ),
        ),
      );
      setListData();

      emitLoading();

      await repository.updateTodo(model);
      // await getAllTodos(isFirsTimeCalling: true);

      emitSuccess();
    } on MyException catch (e) {
      emitError(message: e.message);
    }
  }

  void setListData() {
    preferencesUtil.setPreferencesData(
      AppKeyConstants.todosData,
      state.todoResponseModel.toJson(),
    );
  }

  // loading
  void emitLoading() {
    emit(state.copyWith(status: StatusEnum.loading, message: ''));
  }

// error
  void emitError({String? message}) {
    emit(state.copyWith(
        status: StatusEnum.failed, message: message ?? "Something is wrong"));
  }

// success
  void emitSuccess({String? message}) {
    emit(state.copyWith(
        status: StatusEnum.success,
        message: message ?? "Successfully completed"));
  }
}
