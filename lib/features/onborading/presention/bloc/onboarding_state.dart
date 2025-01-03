import 'package:secondproject/features/onborading/domain/entities/onboarding_step.dart';


abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final List<OnboardingStep> steps;
  final int currentIndex;

  OnboardingLoaded({required this.steps, required this.currentIndex});

  OnboardingLoaded copyWith({int? currentIndex}) {
    return OnboardingLoaded(
      steps: steps,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class OnboardingError extends OnboardingState {
  final String message;

  OnboardingError(this.message);
}
