import 'package:android_glide_view/android_glide_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

class FlutterAndroidGlideView extends StatefulWidget {
  final String imageUrl;
  final Widget Function(BuildContext context, String imageUrl)? buildLoadingWidget;
  final Widget Function(BuildContext context, String imageUrl)? buildErrorWidget;

  const FlutterAndroidGlideView({
    super.key,
    required this.imageUrl,
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
  CheckImageUrlValidResult? _checkImageUrlValidResult;

  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isAndroid == true) {
      _isLoading = true;
      AndroidGlideView().checkImageUrlValid(widget.imageUrl).then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _checkImageUrlValidResult = value;
            print("_checkImageUrlValidResult:$_checkImageUrlValidResult");
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
    if (_checkImageUrlValidResult?.result != true) {
      Widget? errorWidget;
      if (widget.buildErrorWidget != null) {
        errorWidget = widget.buildErrorWidget!(context, widget.imageUrl);
      }
      return errorWidget ?? ErrorWidget("invalid image url");
    }
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = _checkImageUrlValidResult!.imageHeight! / _checkImageUrlValidResult!.imageWidth! * width;
      return SizedBox(
        width: width,
        height: height,
        // AbsorbPointer: 阻止事件传递到背景
        child: AbsorbPointer(
          absorbing: true,
          child: AndroidView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: <String, dynamic>{
              "image_url": widget.imageUrl,
            },
            creationParamsCodec: const StandardMessageCodec(),
          ),
        ),
      );
    });
  }
}
