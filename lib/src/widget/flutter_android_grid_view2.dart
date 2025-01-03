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
      _loadImageModel = AndroidGlideViewManager.findByImageUrl(widget.imageUrl);
      if (_loadImageModel != null) {
        _isLoading = false;
        return;
      }
      _isLoading = true;
      AndroidGlideView().loadImage(widget.imageUrl).then((value) {
        value!.imageWidth = null;
        value.imageHeight = null;
        AndroidGlideViewManager.addCache(widget.imageUrl, value);
        if (mounted) {
          setState(() {
            _isLoading = false;
            _loadImageModel = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _loadImageModel?.imageWidth?.toDouble(),
      height: _loadImageModel?.imageHeight?.toDouble(),
      child: build2(context),
    );
  }

  Widget build2(BuildContext context) {
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
      return Image.memory(
        _loadImageModel!.byteArray!,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
          if (_loadImageModel!.imageWidth == null || _loadImageModel!.imageHeight == null) {
            final imageProvider = MemoryImage(_loadImageModel!.byteArray!);
            final imageStream = imageProvider.resolve(const ImageConfiguration());
            imageStream.addListener(
              ImageStreamListener((ImageInfo info, bool _) {
                _loadImageModel!.imageWidth = constraints.maxWidth.toInt();
                _loadImageModel!.imageHeight = info.image.height * (constraints.maxWidth.toInt()) ~/ info.image.width;
                // print("图片的宽度:${info.image.width} 高度:${info.image.height} 适配的宽度:${_loadImageModel!.imageWidth} 适配的高度:${_loadImageModel!.imageHeight}");
              }),
            );
          }
          return child;
        },
      );
    });
  }
}
