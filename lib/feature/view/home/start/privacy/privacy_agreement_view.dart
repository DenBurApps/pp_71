// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp71/core/storage/storage_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:pp71/core/config/remote_config.dart';
import 'package:pp71/core/keys/storage_keys.dart';
import 'package:pp71/core/routes/routes.dart';
import 'package:pp71/core/utils/dialog_helper.dart';
import 'package:pp71/core/widgets/app_button.dart';

void main() => runApp(const MaterialApp(home: PrivacyAgreementPage()));

class PrivacyAgreementPage extends StatefulWidget {
  const PrivacyAgreementPage({super.key});

  @override
  State<PrivacyAgreementPage> createState() => _PrivacyAgreementPageState();
}

class _PrivacyAgreementPageState extends State<PrivacyAgreementPage> {
  late final WebViewController _controller;
  final _storageService =  GetIt.instance<StorageService>();
  final _remoteConfig =  GetIt.instance<RemoteConfigService>();

  var isLoading = true;
  var agreeButton = false;

  String get _cssCode {
    if (Platform.isAndroid) {
      return """
        .docs-ml-promotion { 
          display: none !important; 
        } 
        #docs-ml-header-id {
          display: none !important;
        }
        .app-container { 
          margin: 0 !important; 
        }
      """;
    }
    return ".docs-ml-promotion, #docs-ml-header-id { display: none !important; } .app-container { margin: 0 !important; }";
  }

  String get _jsCode => """
      var style = document.createElement('style');
      style.type = "text/css";
      style.innerHTML = "$_cssCode";
      document.head.appendChild(style);
    """;

  bool _parseShowAgreeButton(String input) =>
      input.contains('showAgreebutton') || input.contains('showAgreeButton');

  @override
  void initState() {
    super.initState();

    final privacyLink = _remoteConfig.getString(ConfigKey.privacyLink);
    setState(() => agreeButton = _parseShowAgreeButton(privacyLink));

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            log('Page started loading: $url');
          },
          onPageFinished: (String url) {
            controller.runJavaScript(_jsCode);
            log('Page finished loading: $url');
            setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            log('''
              Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
          ''');
            if (error.errorCode == -1009) {
              DialogHelper.showNoInternetDialog(context);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('showAgreebutton')) {
              setState(() => agreeButton = true);
            }
            log('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            log('url change to ${change.url}');
          },
        ),
      )
      ..loadRequest(Uri.parse(privacyLink));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          agreeButton ? Colors.white : Theme.of(context).colorScheme.background,
      body: isLoading
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 15,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : SafeArea(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                                BoxConstraints constraints) =>
                            SizedBox(
                                width: constraints.maxWidth * 0.9,
                                height: 60,
                                child: _AgreementButton(
                                    agree: _agree,
                                   )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _agree() {
    _storageService.setBool(StorageKeys.acceptedPrivacy, true);
    Navigator.of(context).pushReplacementNamed(RouteNames.onbording);
  }
}

// ignore: unused_element
class _AgreementButton extends StatelessWidget {
  final VoidCallback agree;
  const _AgreementButton({
    required this.agree,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(5),
      onPressed: agree,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20)),
          width: double.infinity,
          height: 60,
          child: Text(
            'Agree with privacy',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
