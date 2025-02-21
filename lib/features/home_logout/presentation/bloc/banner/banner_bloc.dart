import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerState(0)) {
    // Handle ChangeBanner event using the new Bloc pattern
    on<ChangeBanner>((event, emit) {
      emit(BannerState(event.newIndex));
    });
  }
}