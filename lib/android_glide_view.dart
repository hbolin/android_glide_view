import 'package:android_glide_view/src/model/check_image_url_valid_model.dart';
import 'package:android_glide_view/src/model/load_image_model.dart';

import 'android_glide_view_platform_interface.dart';
export 'src/widget/flutter_android_grid_view2.dart';
export 'src/model/check_image_url_valid_model.dart';

class AndroidGlideView {
  Future<String?> getPlatformVersion() {
    return AndroidGlideViewPlatform.instance.getPlatformVersion();
  }

  Future<CheckImageUrlValidResult?> checkImageUrlValid(String imageUrl) {
    return AndroidGlideViewPlatform.instance.checkImageUrlValid(imageUrl);
  }

  Future<LoadImageModel?> loadImage(String imageUrl) async {
    return AndroidGlideViewPlatform.instance.loadImage(imageUrl);
  }
}

class AndroidGlideViewManager {
  static final Map<String, LoadImageModel> _cacheLoadImageModelMap = {};

  static LoadImageModel? findByImageUrl(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return _cacheLoadImageModelMap[imageUrl];
    }
    return null;
  }

  static void addCache(String imageUrl, LoadImageModel loadImageModel) {
    if (imageUrl.isNotEmpty) {
      _cacheLoadImageModelMap[imageUrl] = loadImageModel;
    }
  }

  static void clearAllCache() {
    _cacheLoadImageModelMap.clear();
  }
}
