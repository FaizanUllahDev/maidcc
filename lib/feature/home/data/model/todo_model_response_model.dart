import 'dart:convert';

import 'package:maidcc/core/utils/utils.dart';
import 'package:maidcc/feature/home/data/model/todo_model.dart';

class TodoResponseModel {
  final List<TodoModel> todos;
  final int total;
  final int skip;
  final int limit;

  const TodoResponseModel({
    this.todos = const [],
    this.total = 0,
    this.skip = 0,
    this.limit = 10,
  });

  //copy with
  TodoResponseModel copyWith({
    List<TodoModel>? todos,
    int? total,
    int? skip,
    int? limit,
  }) {
    return TodoResponseModel(
      todos: todos ?? this.todos,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  factory TodoResponseModel.fromMap(Map<String, dynamic> json) {
    Utils.debug("fromMap $json");
    if (json == {}) return const TodoResponseModel();
    return TodoResponseModel(
      todos: List<TodoModel>.from(
        json['todos'].map((x) => TodoModel.fromMap(x)),
      ),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todos': List<dynamic>.from(todos.map((x) => x.toMap())),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  // from/to json
  factory TodoResponseModel.fromJson(String str) {
    return TodoResponseModel.fromMap(json.decode(str));
  }

  String toJson() {
    return json.encode(toMap());
  }

  @override
  String toString() {
    return 'TodoResponseModel(todos: $todos, count: $total, skip: $skip, limit: $limit)';
  }
}
