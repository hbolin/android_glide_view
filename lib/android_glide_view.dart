import 'package:android_glide_view/src/model/check_image_url_valid_model.dart';

import 'android_glide_view_platform_interface.dart';
export 'src/widget/flutter_android_grid_view.dart';
export 'src/model/check_image_url_valid_model.dart';

class AndroidGlideView {
  Future<String?> getPlatformVersion() {
    return AndroidGlideViewPlatform.instance.getPlatformVersion();
  }

  Future<CheckImageUrlValidResult?> checkImageUrlValid(String imageUrl) {
    return AndroidGlideViewPlatform.instance.checkImageUrlValid(imageUrl);
  }
}
