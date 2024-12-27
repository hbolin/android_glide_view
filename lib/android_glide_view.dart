
import 'android_glide_view_platform_interface.dart';

class AndroidGlideView {
  Future<String?> getPlatformVersion() {
    return AndroidGlideViewPlatform.instance.getPlatformVersion();
  }
}
