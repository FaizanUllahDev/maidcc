import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<State> extends BlocBase<State> {
  BaseCubit(super.state);
}
