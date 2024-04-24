import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pp71/core/constants/settings_const.dart';
import 'package:pp71/core/constants/text_const.dart';
import 'package:pp71/core/generated/assets.gen.dart';
import 'package:pp71/core/utils/email_helper.dart';
import 'package:pp71/core/widgets/icon_button.dart';
import 'package:theme_provider/theme_provider.dart';

class AgreementPopUp extends StatelessWidget {
  final AgreementType agreementType;
  const AgreementPopUp({super.key, required this.agreementType});

  String get _body => agreementType == AgreementType.privacy
      ? TextHelper.privacy
      : TextHelper.terms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: CustomIconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Assets.icons.esc,
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            agreementType == AgreementType.privacy
                ? 'Privacy Policy'
                : 'Terms of use',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onBackground),
          )),
      body: Material(
        clipBehavior: Clip.hardEdge,
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: MarkdownBody(
                    data: _body,
                    onTapLink: (text, href, title) =>
                        EmailHelper.launchEmailSubmission(
                      toEmail: text,
                      subject: 'Connect with support',
                      errorCallback: () {},
                      doneCallback: () {},
                    ),
                    styleSheet: MarkdownStyleSheet.fromTheme(
                        ThemeProvider.themeOf(context).data),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
