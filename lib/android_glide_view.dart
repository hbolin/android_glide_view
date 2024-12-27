import 'android_glide_view_platform_interface.dart';
export 'src/widget/flutter_android_grid_view.dart';

class AndroidGlideView {
  Future<String?> getPlatformVersion() {
    return AndroidGlideViewPlatform.instance.getPlatformVersion();
  }

  Future<bool?> checkImageUrlValid(String imageUrl) {
    return AndroidGlideViewPlatform.instance.checkImageUrlValid(imageUrl);
  }
}
