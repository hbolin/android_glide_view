import 'package:android_glide_view/android_glide_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

class FlutterAndroidGlideView extends StatefulWidget {
  final String imageUrl;
  final BoxFit boxFit;
  final Widget Function(BuildContext context, String imageUrl)? buildLoadingWidget;
  final Widget Function(BuildContext context, String imageUrl)? buildErrorWidget;

  const FlutterAndroidGlideView({
    super.key,
    required this.imageUrl,
    this.boxFit = BoxFit.none,
    this.buildLoadingWidget,
    this.buildErrorWidget,
  });

  @override
  State<FlutterAndroidGlideView> createState() => _FlutterAndroidGlideViewState();
}

class _FlutterAndroidGlideViewState extends State<FlutterAndroidGlideView> {
  // This is used in the platform side to register the view.
  static const String viewType = 'FlutterAndroidGlideView';

  bool _isLoading = true;
  bool? _imageUrlValid;

  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isAndroid == true) {
      _isLoading = true;
      AndroidGlideView().checkImageUrlValid(widget.imageUrl).then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _imageUrlValid = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isAndroid != true) {
      if (kDebugMode) {
        return ErrorWidget('platformVersion() has not been implemented.');
      }
      return const SizedBox.shrink();
    }
    if (_isLoading) {
      Widget? loadingWidget;
      if (widget.buildLoadingWidget != null) {
        loadingWidget = widget.buildLoadingWidget!(context, widget.imageUrl);
      }
      return loadingWidget ?? const CupertinoActivityIndicator();
    }
    if (_imageUrlValid != true) {
      Widget? errorWidget;
      if (widget.buildErrorWidget != null) {
        errorWidget = widget.buildErrorWidget!(context, widget.imageUrl);
      }
      return errorWidget ?? ErrorWidget("invalid image url");
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
