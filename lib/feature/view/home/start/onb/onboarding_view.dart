import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/keys/storage_keys.dart';
import 'package:pp71/core/routes/routes.dart';
import 'package:pp71/core/storage/storage_service.dart';
import 'package:pp71/core/widgets/app_button.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  var _currentStep = 0;
  final _storageService = GetIt.instance<StorageService>();

  List _steps = [];

  _OnboardingStep get _currentOnboarding => _steps[_currentStep];

  @override
  void initState() {
    super.initState();
  }

  void _progress() async {
    if (_currentStep == 2) {
      _storageService.setBool(StorageKeys.seenOnboarding, true);
      Navigator.of(context).pushReplacementNamed(RouteNames.pages);
    } else {
      setState(() => _currentStep++);
    }
  }

  @override
  Widget build(BuildContext context) {
    _steps = [
      _OnboardingStep(
        text: const OnbTextWidgets(
          text1: 'Create customer cards',
          text2:
              'Add complete information about\nyour customers and keep a directory\nof all customers.',
        ),
        backgorund: Assets.images.onb1,
      ),
      _OnboardingStep(
        text: const OnbTextWidgets(
          text1: 'Create order cards',
          text2: 'Save all important information\nabout orders.',
        ),
        backgorund: Assets.images.onb2,
      ),
      _OnboardingStep(
        text: const OnbTextWidgets(
          text1: 'Study the statistics',
          text2: 'Watch the statistics of your orders\nand customers.',
        ),
        backgorund: Assets.images.onb3,
      ),
    ];
    return Container(
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
                width: 0.9 * MediaQuery.of(context).size.width,
                fontSize: 24,
                color: _currentStep == 2 ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.primary ,
                onPressed: _progress,
                label: _currentStep == 2 ? 'Get started!' : 'Next'),
            const SizedBox(height: 10),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressBar(
                    maxSteps: 10,
                    progressType: LinearProgressBar.progressTypeLinear,
                    currentStep: _currentStep == 0 ? 3 : _currentStep == 1 ? 7 : 10,
                    progressColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary),
                    minHeight: 4.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: _currentOnboarding.backgorund.image(
                    width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
              ),
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _currentOnboarding.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnbTextWidgets extends StatelessWidget {
  const OnbTextWidgets({
    super.key,
    required this.text1,
    required this.text2,
  });

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text1,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        const SizedBox(height: 15),
        Text(
          text2,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
        ),
        const SizedBox(height: 150)
      ],
    );
  }
}

class _OnboardingStep {
  final Widget text;
  final AssetGenImage backgorund;

  const _OnboardingStep({
    required this.text,
    required this.backgorund,
  });
}
