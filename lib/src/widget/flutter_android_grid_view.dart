import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

class FlutterAndroidGlideView extends StatefulWidget {
  final String imageUrl;
  final BoxFit boxFit;

  const FlutterAndroidGlideView({
    super.key,
    required this.imageUrl,
    this.boxFit = BoxFit.none,
  });

  @override
  State<FlutterAndroidGlideView> createState() => _FlutterAndroidGlideViewState();
}

class _FlutterAndroidGlideViewState extends State<FlutterAndroidGlideView> {
  // This is used in the platform side to register the view.
  static const String viewType = 'FlutterAndroidGlideView';

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isAndroid != true) {
      if (kDebugMode) {
        return ErrorWidget('platformVersion() has not been implemented.');
      }
      return const SizedBox.shrink();
    }
    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: <String, dynamic>{
        "image_url": widget.imageUrl,
        "box_fit": boxFitToInt(widget.boxFit),
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  int boxFitToInt(BoxFit boxFit) {
    switch (boxFit) {
      case BoxFit.fill:
        return 1;
      case BoxFit.contain:
        return 2;
      case BoxFit.cover:
        return 3;
      case BoxFit.fitWidth:
        return 4;
      case BoxFit.fitHeight:
        return 5;
      case BoxFit.none:
        return 6;
      case BoxFit.scaleDown:
        return 7;
    }
  }
}
