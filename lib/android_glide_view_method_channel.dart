import 'package:android_glide_view/src/model/check_image_url_valid_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'android_glide_view_platform_interface.dart';

/// An implementation of [AndroidGlideViewPlatform] that uses method channels.
class MethodChannelAndroidGlideView extends AndroidGlideViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('android_glide_view');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<CheckImageUrlValidResult?> checkImageUrlValid(String imageUrl) async {
    final result = await methodChannel.invokeMethod<Map>('checkImageUrlValid', {
      "image_url": imageUrl,
    });
    return CheckImageUrlValidResult(
      result: result!["result"],
      imageWidth: result["image_width"],
      imageHeight: result["image_height"],
    );
  }
}
