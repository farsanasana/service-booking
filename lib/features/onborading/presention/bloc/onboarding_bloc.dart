import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/onborading/domain/respositories/onboarding_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;

  OnboardingBloc(this.repository) : super(OnboardingInitial()) {
    on<LoadOnboardingSteps>((event, emit) async {
      emit(OnboardingLoading());
      try {
        final steps = repository.fetchSteps();
        emit(OnboardingLoaded(steps: steps, currentIndex: 0));
      } catch (e) {
        emit(OnboardingError('Failed to load onboarding steps.'));
      }
    });

    on<ChangeOnboardingStep>((event, emit) {
      final currentState = state;
      if (currentState is OnboardingLoaded) {
        emit(currentState.copyWith(currentIndex: event.newIndex));
      }
    });
  }
}
