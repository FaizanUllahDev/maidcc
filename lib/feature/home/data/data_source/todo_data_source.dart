import 'package:maidcc/core/network/network_client.dart';
import 'package:maidcc/core/network/network_constants.dart';
import 'package:maidcc/core/network/network_exceptions.dart';
import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/feature/home/data/model/todo_model.dart';
import 'package:maidcc/feature/home/data/model/todo_model_response_model.dart';
import 'package:maidcc/feature/home/data/model/todo_request_model.dart';
import 'package:maidcc/feature/home/domain/todo_repository.dart';

class TodoDataSource implements TodoRepository {
  final NetworkClient client;

  TodoDataSource(this.client);

  @override
  Future<TodoResponseModel> getTodos(TodoRequestModel model) async {
    try {
      final response = await client.invoke(
        kTodosUser + Utils.currentUser.id.toString(),
        RequestType.get,
        queryParameters: model.toJson(),
      );
      return TodoResponseModel.fromMap(response.data ?? {});
    } on MyException catch (e) {
      Utils.debug(e.message);
      rethrow;
    }
  }

  @override
  Future<void> addTodo(TodoModel model) async {
    try {
      final response = await client.invoke(
        kTodosAdd,
        RequestType.post,
        requestBody: model.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTodo(TodoModel model) async {
    try {
      await client.invoke(
        kTodos + model.id.toString(),
        RequestType.put,
        requestBody: {
          "todo": model.todo,
          "completed": model.completed,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTodo(int? id) async {
    try {
      await client.invoke(
        kTodos + id.toString(),
        RequestType.delete,
      );
    } catch (e) {
      rethrow;
    }
  }
}
