import 'package:maidcc/feature/home/data/model/todo_model.dart';
import 'package:maidcc/feature/home/data/model/todo_model_response_model.dart';
import 'package:maidcc/feature/home/data/model/todo_request_model.dart';

abstract class TodoRepository {
  Future<TodoResponseModel> getTodos(TodoRequestModel model);

  //add
  Future<void> addTodo(TodoModel model);

  //update
  Future<void> updateTodo(TodoModel model);

  //delete
  Future<void> deleteTodo(int? id);
}
