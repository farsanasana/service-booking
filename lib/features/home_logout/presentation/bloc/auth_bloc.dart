
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:secondproject/features/home_logout/domain/usecases/logout.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/auth_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/auth_state.dart';



class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutBloc(this.logoutUseCase) : super(LogoutInitial()) {
    on<LogoutRequested>((event, emit) async {
      emit(LogoutLoading());
      try {
        await logoutUseCase.execute();
        emit(LogoutSuccess());
      } catch (e) {
        emit(LogoutFailure(message: e.toString()));
      }
    });
  }
}
