import 'package:flutter/material.dart';
import 'package:pp71/core/widgets/support.dart';
import 'package:pp71/feature/view/home/pages/home_view.dart';
import 'package:pp71/feature/view/home/start/onb/onboarding_view.dart';
import 'package:pp71/feature/view/home/start/privacy/privacy_agreement_view.dart';
import 'package:pp71/feature/view/home/start/splash/splash_view.dart';


part 'names.dart';

typedef AppRoute = Widget Function(BuildContext context);

class Routes {
  static Map<String, AppRoute> get(BuildContext context) => {
        RouteNames.splash: (context) => const SplashPage(),
        RouteNames.pages: (context) => const Homeview(),
        RouteNames.support: (context) => const SupportView(),
        RouteNames.privacyAgreement: (context) => const PrivacyAgreementPage(),
        RouteNames.onbording: (context) => const OnboardingView(),
      };
}

