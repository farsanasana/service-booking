import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/onborading/data/onboarding_repository_impl.dart';
import 'package:secondproject/features/onborading/presention/bloc/onboarding_bloc.dart';
import 'package:secondproject/features/onborading/presention/bloc/onboarding_event.dart';
import 'package:secondproject/features/onborading/presention/bloc/onboarding_state.dart';
import 'package:secondproject/features/onborading/widgets/onboarding_step_widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(OnboardingRepositoryImpl())
        ..add(LoadOnboardingSteps()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('Skip >>', style: TextStyle(color: ColorSys.secoundry)),
            ),
          ],
        ),
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OnboardingLoaded) {
              return _OnboardingContent(state: state);
            } else if (state is OnboardingError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  final OnboardingLoaded state;

  const _OnboardingContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<OnboardingBloc>(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(state.steps.length, (index) {
              return 
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 6,
      width: state.currentIndex == index ? 30 : 6,
      margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                //shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(5),
                color: state.currentIndex == index ? ColorSys.secoundry : ColorSys.gray,
              ),
            );
          }),
        ),
        PageView.builder(
          controller: PageController(initialPage: state.currentIndex),
          itemCount: state.steps.length,
          onPageChanged: (index) {
            bloc.add(ChangeOnboardingStep(index));
          },
          itemBuilder: (context, index) {
            final step = state.steps[index];
            return OnboardingStepWidget(
              step: step,
              reverse: index.isOdd,
            );
          },
        ),
      ],
    );
  }
}
