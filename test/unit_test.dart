import 'dart:ffi';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maidcc/core/db/preferance_utils.dart';
import 'package:maidcc/core/enums/enums.dart';
import 'package:maidcc/core/network/network_info.dart';
import 'package:maidcc/feature/auth/data/models/user_model.dart';
import 'package:maidcc/feature/auth/domain/login_respository.dart';
import 'package:maidcc/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:maidcc/feature/auth/presentation/cubit/login_state.dart';
import 'package:maidcc/feature/home/data/model/todo_model.dart';
import 'package:maidcc/feature/home/data/model/todo_model_response_model.dart';
import 'package:maidcc/feature/home/domain/todo_repository.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_cubit.dart';
import 'package:maidcc/feature/home/presentation/cubit/todo_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<LoginRepository>()])
@GenerateNiceMocks([MockSpec<PreferencesUtil>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
@GenerateNiceMocks([MockSpec<UserEntity>()])
@GenerateNiceMocks([MockSpec<TodoRepository>()])
@GenerateNiceMocks([MockSpec<TodoResponseModel>()])
import 'unit_test.mocks.dart';
void main () {
  late MockLoginRepository mockLoginRepository;
  late MockPreferencesUtil mockPreferencesUtil;
  late MockTodoRepository mockTodoRepository;
  late MockNetworkInfo mockNetworkInfo;


 late LoginCubit loginCubit;
 late TodoCubit todoCubit;

  setUp((){
    mockLoginRepository = MockLoginRepository();
    mockPreferencesUtil = MockPreferencesUtil();
    mockTodoRepository = MockTodoRepository();
    mockNetworkInfo = MockNetworkInfo();

    loginCubit = LoginCubit(mockLoginRepository, mockPreferencesUtil);
    todoCubit = TodoCubit(mockTodoRepository, mockNetworkInfo, mockPreferencesUtil);
  });

  tearDown(() {
    loginCubit.close();
    todoCubit.close();
  });

  group('LoginCubit states', () {
    test('initial state is LoginInitial', () {
      expect(loginCubit.state, LoginState());
    });

    blocTest<LoginCubit, LoginState>('login should emit [RequestStatus.loading] and [RequestStatus.success]', build: () => loginCubit, act: (cubit) {
      // Arrange
      when(mockLoginRepository.login(any, any)).thenAnswer((_) async =>  UserEntity(
        id: 1,
      ));

      // Act
      cubit.login('abc', '123');
    }, expect: () => [
      isA<LoginState>()
      .having((s) => s.status, 'status', StatusEnum.loading),
      isA<LoginState>()
      .having((s) => s.status, 'status', StatusEnum.success)
    ] );

    blocTest<LoginCubit, LoginState>('login should emit [RequestStatus.loading] and [RequestStatus.failed]', build: () => loginCubit, act: (cubit) {
      // Arrange
      when(mockLoginRepository.login(any, any)).thenAnswer((_) async =>  MockUserEntity());

      // Act
      cubit.login('null', '123');
    }, expect: () => [
      isA<LoginState>()
          .having((s) => s.status, 'status', StatusEnum.loading),
      isA<LoginState>()
          .having((s) => s.status, 'status', StatusEnum.failed)
    ] );
  });


  group('Todo cubit', () {
    test('initial state is TodoInitial', () {
      expect(todoCubit.state, TodoState());
    });

    blocTest<TodoCubit, TodoState>('getTodo should emit [RequestStatus.loading] and [RequestStatus.success]', build: () => todoCubit, act: (cubit) {
      // Arrange
      when(mockTodoRepository.getTodos(any)).thenAnswer((_) async =>  TodoResponseModel(
        todos: [
          TodoModel(
            1,'Todo', false, 1,
          )
        ],
      ));

      // Act
      cubit.getAllTodos(isFirsTimeCalling: false);
    },  expect: () => [
      isA<TodoState>()
          .having((s) => s.status, 'status', StatusEnum.loading),
      isA<TodoState>()
          .having((s) => s.status, 'status', StatusEnum.success)
    ]);

    blocTest<TodoCubit, TodoState>('getTodo should emit [RequestStatus.loading] and [RequestStatus.failed]', build: () => todoCubit, act: (cubit) {
      // Arrange
      when(mockTodoRepository.getTodos(any)).thenAnswer((_) async =>  const TodoResponseModel());

      // Act
      cubit.getAllTodos(isFirsTimeCalling: false);
    },  expect: () => [
      isA<TodoState>()
          .having((s) => s.status, 'status', StatusEnum.loading),
      isA<TodoState>()
      .having((s) => s.todoResponseModel, 'todoResponseModel', TodoResponseModel())
    ]);
  });

}