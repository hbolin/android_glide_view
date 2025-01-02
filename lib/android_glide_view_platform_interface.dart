import 'package:android_glide_view/src/model/check_image_url_valid_model.dart';
import 'package:android_glide_view/src/model/load_image_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'android_glide_view_method_channel.dart';

abstract class AndroidGlideViewPlatform extends PlatformInterface {
  /// Constructs a AndroidGlideViewPlatform.
  AndroidGlideViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static AndroidGlideViewPlatform _instance = MethodChannelAndroidGlideView();

  /// The default instance of [AndroidGlideViewPlatform] to use.
  ///
  /// Defaults to [MethodChannelAndroidGlideView].
  static AndroidGlideViewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AndroidGlideViewPlatform] when
  /// they register themselves.
  static set instance(AndroidGlideViewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<CheckImageUrlValidResult?> checkImageUrlValid(String imageUrl) async {
    throw UnimplementedError('checkImageUrlValid() has not been implemented.');
  }

  Future<LoadImageModel?> loadImage(String imageUrl) async {
    throw UnimplementedError('checkImageUrlValid() has not been implemented.');
  }
}
