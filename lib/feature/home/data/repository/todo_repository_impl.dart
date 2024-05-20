import 'package:maidcc/feature/home/data/data_source/todo_data_source.dart';
import 'package:maidcc/feature/home/data/model/todo_model.dart';
import 'package:maidcc/feature/home/data/model/todo_model_response_model.dart';
import 'package:maidcc/feature/home/data/model/todo_request_model.dart';
import 'package:maidcc/feature/home/domain/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource dataSource;

  TodoRepositoryImpl(this.dataSource);

  @override
  Future<TodoResponseModel> getTodos(TodoRequestModel model) {
    return dataSource.getTodos(model);
  }

  @override
  Future<void> addTodo(TodoModel model) {
    return dataSource.addTodo(model);
  }

  @override
  Future<void> updateTodo(TodoModel model) {
    return dataSource.updateTodo(model);
  }

  @override
  Future<void> deleteTodo(int? id) {
    return dataSource.deleteTodo(id);
  }
}
