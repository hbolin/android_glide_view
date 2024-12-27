import 'package:flutter_test/flutter_test.dart';
import 'package:android_glide_view/android_glide_view.dart';
import 'package:android_glide_view/android_glide_view_platform_interface.dart';
import 'package:android_glide_view/android_glide_view_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAndroidGlideViewPlatform
    with MockPlatformInterfaceMixin
    implements AndroidGlideViewPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AndroidGlideViewPlatform initialPlatform = AndroidGlideViewPlatform.instance;

  test('$MethodChannelAndroidGlideView is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAndroidGlideView>());
  });

  test('getPlatformVersion', () async {
    AndroidGlideView androidGlideViewPlugin = AndroidGlideView();
    MockAndroidGlideViewPlatform fakePlatform = MockAndroidGlideViewPlatform();
    AndroidGlideViewPlatform.instance = fakePlatform;

    expect(await androidGlideViewPlugin.getPlatformVersion(), '42');
  });
}
