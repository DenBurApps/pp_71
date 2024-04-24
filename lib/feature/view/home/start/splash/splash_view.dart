import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:pp71/core/keys/storage_keys.dart';
import 'package:pp71/core/routes/routes.dart';
import 'package:pp71/core/storage/storage_service.dart';
import 'package:pp71/core/utils/dialog_helper.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _storageService = GetIt.instance<StorageService>();
  final _connectivity = Connectivity();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await _initConnectivity(
      () async => await DialogHelper.showNoInternetDialog(context),
    );

    _navigate();
  }

  Future<void> _initConnectivity(Future<void> Function() callback) async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        await callback.call();
        return;
      }
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }
  }

  void _navigate() {
    final acceptedPrivacy =
        _storageService.getBool(StorageKeys.acceptedPrivacy) ?? false;
    if (!acceptedPrivacy) {
      Navigator.of(context).pushReplacementNamed(RouteNames.privacyAgreement);
    } else {
      final seenOnboarding =
          _storageService.getBool(StorageKeys.seenOnboarding) ?? false;
      Navigator.of(context).pushReplacementNamed(
          !seenOnboarding ? RouteNames.onbording : RouteNames.pages);
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
