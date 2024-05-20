import 'package:maidcc/core/enums/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:maidcc/feature/home/data/model/todo_model.dart';
import 'package:maidcc/feature/home/data/model/todo_model_response_model.dart';

class TodoState extends Equatable {
  StatusEnum status;
  String message;
  TodoResponseModel todoResponseModel;

  TodoState({
    this.status = StatusEnum.initial,
    this.message = '',
    this.todoResponseModel = const TodoResponseModel(),
  });

  @override
  // TODO: implement props
  List<Object?> get props => [status, message, todoResponseModel];

  TodoState copyWith({
    StatusEnum? status,
    String? message,
    TodoResponseModel? todoResponseModel,
  }) {
    return TodoState(
      status: status ?? this.status,
      message: message ?? this.message,
      todoResponseModel: todoResponseModel ?? this.todoResponseModel,
    );
  }
}
