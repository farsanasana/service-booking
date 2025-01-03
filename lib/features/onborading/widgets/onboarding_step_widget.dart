import 'package:flutter/material.dart';
import 'package:secondproject/features/onborading/domain/entities/onboarding_step.dart';

class OnboardingStepWidget extends StatelessWidget {
  final OnboardingStep step;
  final bool reverse;

  const OnboardingStepWidget({super.key, 
    required this.step,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!reverse) ...[
            Image.asset(step.image),
            const SizedBox(height: 20),
          ],
          Text(
            step.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            step.content,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (reverse) ...[
            const SizedBox(height: 20),
            Image.asset(step.image),
          ],
        ],
      ),
    );
  }
}
