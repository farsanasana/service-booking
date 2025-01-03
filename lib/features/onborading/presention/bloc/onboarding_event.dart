abstract class OnboardingEvent {}

class LoadOnboardingSteps extends OnboardingEvent {}

class ChangeOnboardingStep extends OnboardingEvent {
  final int newIndex;

  ChangeOnboardingStep(this.newIndex);
}

