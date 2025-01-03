import 'package:secondproject/features/onborading/domain/entities/onboarding_step.dart';

abstract class OnboardingRepository {
  List<OnboardingStep> fetchSteps();
}
