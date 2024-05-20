import 'dart:convert';

class TodoModel {
  // "id": 1,
  // "todo": "Do something nice for someone I care about",
  // "completed": true,
  // "userId": 26

  int id;
  String todo;
  bool completed;
  int userId;

  TodoModel(this.id, this.todo, this.completed, this.userId);

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      map['id'] ?? 0,
      map['todo'],
      map['completed'],
      map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }

  // to/from Json
  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TodoModel{id: $id, todo: $todo, completed: $completed, userId: $userId}';
  }
}
