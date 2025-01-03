import 'package:bloc/bloc.dart';
import '../../domain/entities/navigation_tab.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(selectedTab: NavigationTab.home)) {
    on<TabChanged>((event, emit) {
      emit(NavigationState(selectedTab: event.tab));
    });
  }
}
