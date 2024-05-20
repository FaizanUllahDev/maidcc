import 'package:maidcc/core/enums/enums.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  StatusEnum status;
  String message;

  LoginState({
    this.status = StatusEnum.initial,
    this.message = '',
  });

  @override
  // TODO: implement props
  List<Object?> get props => [status, message];

  LoginState copyWith({StatusEnum? status, String? message}) {
    return LoginState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
