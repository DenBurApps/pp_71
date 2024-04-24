import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RateUsDialog extends StatefulWidget {
  final ThemeData theme;

  const RateUsDialog({super.key, required this.theme});

  @override
  State<RateUsDialog> createState() => _RateUsDialogState();
}

class _RateUsDialogState extends State<RateUsDialog> {
  int _selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Please rate us 5 stars on the application website',
                    style: widget.theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.theme.colorScheme.background,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStars = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              Icons.star,
                              size: 35,
                              color: index < _selectedStars
                                  ? Theme.of(context).colorScheme.onBackground
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: widget.theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
               Flexible(
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration:  BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(
                          'Send',
                          style: widget.theme.textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void showRateUsDialog(BuildContext context, ThemeData theme) {
  showDialog(
     barrierColor: Theme.of(context).colorScheme.background.withOpacity(0.8),
    context: context,
    builder: (context) => RateUsDialog(theme: theme),
  );
}
