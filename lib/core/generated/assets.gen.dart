/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Message.svg
  SvgGenImage get message => const SvgGenImage('assets/icons/Message.svg');

  /// File path: assets/icons/Phone.svg
  SvgGenImage get phone => const SvgGenImage('assets/icons/Phone.svg');

  /// File path: assets/icons/Setting_line.svg
  SvgGenImage get settingLine =>
      const SvgGenImage('assets/icons/Setting_line.svg');

  /// File path: assets/icons/Statistics.svg
  SvgGenImage get statistics =>
      const SvgGenImage('assets/icons/Statistics.svg');

  /// File path: assets/icons/Tumer.svg
  SvgGenImage get tumer => const SvgGenImage('assets/icons/Tumer.svg');

  /// File path: assets/icons/User_alt_light.svg
  SvgGenImage get userAltLight =>
      const SvgGenImage('assets/icons/User_alt_light.svg');

  /// File path: assets/icons/arrow-down.svg
  SvgGenImage get arrowDown => const SvgGenImage('assets/icons/arrow-down.svg');

  /// File path: assets/icons/arrowR.svg
  SvgGenImage get arrowR => const SvgGenImage('assets/icons/arrowR.svg');

  /// File path: assets/icons/boxempty.svg
  SvgGenImage get boxempty => const SvgGenImage('assets/icons/boxempty.svg');

  /// File path: assets/icons/edit.svg
  SvgGenImage get edit => const SvgGenImage('assets/icons/edit.svg');

  /// File path: assets/icons/energy.svg
  SvgGenImage get energy => const SvgGenImage('assets/icons/energy.svg');

  /// File path: assets/icons/esc.svg
  SvgGenImage get esc => const SvgGenImage('assets/icons/esc.svg');

  /// File path: assets/icons/escblacksvg.svg
  SvgGenImage get escblacksvg =>
      const SvgGenImage('assets/icons/escblacksvg.svg');

  /// File path: assets/icons/fair.svg
  SvgGenImage get fair => const SvgGenImage('assets/icons/fair.svg');

  /// File path: assets/icons/plus.svg
  SvgGenImage get plus => const SvgGenImage('assets/icons/plus.svg');

  /// File path: assets/icons/plus_big.svg
  SvgGenImage get plusBig => const SvgGenImage('assets/icons/plus_big.svg');

  /// File path: assets/icons/trash.svg
  SvgGenImage get trash => const SvgGenImage('assets/icons/trash.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        message,
        phone,
        settingLine,
        statistics,
        tumer,
        userAltLight,
        arrowDown,
        arrowR,
        boxempty,
        edit,
        energy,
        esc,
        escblacksvg,
        fair,
        plus,
        plusBig,
        trash
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/launcher.png
  AssetGenImage get launcher =>
      const AssetGenImage('assets/images/launcher.png');

  /// File path: assets/images/onb1.png
  AssetGenImage get onb1 => const AssetGenImage('assets/images/onb1.png');

  /// File path: assets/images/onb2.png
  AssetGenImage get onb2 => const AssetGenImage('assets/images/onb2.png');

  /// File path: assets/images/onb3.png
  AssetGenImage get onb3 => const AssetGenImage('assets/images/onb3.png');

  /// List of all assets
  List<AssetGenImage> get values => [launcher, onb1, onb2, onb3];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
