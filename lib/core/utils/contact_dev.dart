import 'package:flutter/material.dart';
import 'package:pp71/core/utils/email_helper.dart';
import 'package:pp71/core/widgets/app_button.dart';
import 'package:pp71/core/widgets/feilds/names.dart';

Widget showContactDevoloper(
  BuildContext context,
  TextEditingController controller,
) {
  return SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About Us',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 14.0),
              Text(
                'Write anything you want to tell us about',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(height: 6.0),
              NamesFieldWidget(
                controller: controller,
                titleHint: 'Send your message',
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppButton(
            onPressed: () async {
              EmailHelper.launchEmailSubmission(
                  toEmail: 'Qasim8262922@gmail.com',
                  subject: 'Connect with support',
                  body: controller.text,
                  errorCallback: () {},
                  doneCallback: () {});
              Navigator.pop(context);
            },
            label: 'Send',
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}
