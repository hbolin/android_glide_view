import 'package:android_glide_view/android_glide_view.dart';
import 'package:android_glide_view/src/model/load_image_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';

class FlutterAndroidGlideView2 extends StatefulWidget {
  final String imageUrl;
  final Widget Function(BuildContext context, String imageUrl)? buildLoadingWidget;
  final Widget Function(BuildContext context, String imageUrl)? buildErrorWidget;

  const FlutterAndroidGlideView2({
    super.key,
    required this.imageUrl,
    this.buildLoadingWidget,
    this.buildErrorWidget,
  });

  @override
  State<FlutterAndroidGlideView2> createState() => _FlutterAndroidGlideView2State();
}

class _FlutterAndroidGlideView2State extends State<FlutterAndroidGlideView2> {
  bool _isLoading = true;
  LoadImageModel? _loadImageModel;

  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isAndroid == true) {
      _isLoading = true;
      AndroidGlideView().loadImage(widget.imageUrl).then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _loadImageModel = value;
            print("_loadImageModel:$_loadImageModel");
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
    if (_loadImageModel?.result != true) {
      Widget? errorWidget;
      if (widget.buildErrorWidget != null) {
        errorWidget = widget.buildErrorWidget!(context, widget.imageUrl);
      }
      return errorWidget ?? ErrorWidget("invalid image url");
    }
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = _loadImageModel!.imageHeight! / _loadImageModel!.imageWidth! * width;
      return Image.memory(
        _loadImageModel!.byteArray!,
        width: width,
        height: height,
      );
    });
  }
}
