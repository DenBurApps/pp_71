import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;
  final String label;
  bool? isBorder;
  double? height;
  Color? color;
  double? width;
  double? fontSize;

  AppButton({
    super.key,
    required this.onPressed,
    this.isActive = true,
    required this.label,
    this.isBorder,
    this.height,
    this.width,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: isActive ? onPressed : null,
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        height: height != null ? height! : 55,
        width: width != null ? width! : 145,
        decoration: BoxDecoration(
          color: isActive ? color ?? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(30),
          border: isBorder != null
              ? isBorder!
                  ? Border.all(
                      color: Theme.of(context).colorScheme.onBackground)
                  : null
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: fontSize ?? Theme.of(context).textTheme.displayLarge!.fontSize,
              color: isActive ? isBorder != null
                  ? isBorder!
                      ? Theme.of(context).colorScheme.onBackground
                      : Theme.of(context).colorScheme.onBackground
                  : Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
        ),
      ),
    );
  }
}
