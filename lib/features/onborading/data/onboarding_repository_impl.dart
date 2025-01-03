

import 'package:secondproject/features/onborading/domain/entities/onboarding_step.dart';
import 'package:secondproject/features/onborading/domain/respositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  List<OnboardingStep> fetchSteps() {
    return [
      OnboardingStep(
        image: 'assets/images/step-one.jpg',
        title: 'Welcome to App',
        content: 'This is the first step of the onboarding process.',
      ),
      OnboardingStep(
        image: 'assets/images/step-two.jpg',
        title: 'Explore Features',
        content: 'Learn about all the features we provide.',
      ),
      OnboardingStep(
        image: 'assets/images/step-three.jpeg',
        title: 'Get Started',
        content: 'Start using the app and enjoy the experience!',
      ),
    ];
  }
}
