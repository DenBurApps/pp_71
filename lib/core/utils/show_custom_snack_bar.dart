import 'package:flutter/material.dart';

bool _isSnackBarShown = false;
void showCustomSnackBar(BuildContext context, String txt) {
  if (!_isSnackBarShown) {
    _isSnackBarShown = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          padding: const EdgeInsets.all(0),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.shadow,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      txt,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ))
        .closed
        .then((reason) {
      _isSnackBarShown = false; 
    });
  }
}
