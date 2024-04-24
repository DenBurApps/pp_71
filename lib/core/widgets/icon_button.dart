import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pp71/core/generated/assets.gen.dart';

// ignore: must_be_immutable
class CustomIconButton extends StatelessWidget {
  SvgGenImage? icon;
  final Function() onPressed;
  SvgPicture? colorIcons;
  CustomIconButton(
      {super.key, required this.onPressed, this.icon, this.colorIcons});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        minSize: 0,
        // ignore: deprecated_member_use_from_same_package
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: colorIcons != null
            ? colorIcons!
            // ignore: deprecated_member_use_from_same_package
            : icon?.svg() ??
                const SizedBox.shrink());
  }
}
