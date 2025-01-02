package com.dy.android_glide_view;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.util.DisplayMetrics;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dy.android_glide_view.widget.FlutterAndroidGlideViewFactory;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AndroidGlideViewPlugin */
public class AndroidGlideViewPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private static Integer screenWidth;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "android_glide_view");
    channel.setMethodCallHandler(this);
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("FlutterAndroidGlideView", new FlutterAndroidGlideViewFactory(flutterPluginBinding.getBinaryMessenger()));
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("checkImageUrlValid")) {
        String imageUrl =  call.argument("image_url");
        Log.d("android_glide_view","checkImageUrlValid image_url is " + imageUrl);
        Glide.with(context).load(imageUrl).listener(new RequestListener<Drawable>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, @Nullable Object model, @NonNull Target<Drawable> target, boolean isFirstResource) {
                Map<String, Object> creationParams = new HashMap<>();
                creationParams.put("result", false);
                result.success(creationParams);
                return false;
            }

            @Override
            public boolean onResourceReady(@NonNull Drawable resource, @NonNull Object model, Target<Drawable> target, @NonNull DataSource dataSource, boolean isFirstResource) {
                int width = resource.getIntrinsicWidth(); // 获取图像宽度
                int height = resource.getIntrinsicHeight(); // 获取图像高度
                Map<String, Object> creationParams = new HashMap<>();
                creationParams.put("result", true);
                creationParams.put("image_width", width);
                creationParams.put("image_height", height);
                result.success(creationParams);
                return false;
            }
        }).submit();
    } else if(call.method.equals("loadImage")) {
        String imageUrl = call.argument("image_url");
        Glide.with(context).asBitmap().load(imageUrl).diskCacheStrategy(DiskCacheStrategy.ALL).listener(new RequestListener<Bitmap>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, @Nullable Object model, @NonNull Target<Bitmap> target, boolean isFirstResource) {
                Map<String, Object> creationParams = new HashMap<>();
                creationParams.put("result", false);
                result.success(creationParams);
                return false;
            }

            @Override
            public boolean onResourceReady(@NonNull Bitmap resource, @NonNull Object model, Target<Bitmap> target, @NonNull DataSource dataSource, boolean isFirstResource) {
                if (screenWidth == null) {
                    // 获取屏幕宽度和高度
                    DisplayMetrics displayMetrics = new DisplayMetrics();
                    WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
                    windowManager.getDefaultDisplay().getMetrics(displayMetrics);
                    screenWidth = displayMetrics.widthPixels;
                    int height = displayMetrics.heightPixels;
                }
                int width = resource.getWidth(); // 获取图像宽度
                int height = resource.getHeight(); // 获取图像高度
                int quality = 100;
                if (width > screenWidth) {
                    quality = screenWidth / width;
                }
                Log.d("android_glide_view", "screenWidth is " + screenWidth + " image width is " + width + " compress quality is " + quality);

                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                resource.compress(Bitmap.CompressFormat.PNG, quality, byteArrayOutputStream);
                byte[] byteArray = byteArrayOutputStream.toByteArray(); // 返回图片的 byte[]
                Map<String, Object> creationParams = new HashMap<>();
                creationParams.put("result", true);
                creationParams.put("image_width", width);
                creationParams.put("image_height", height);
                creationParams.put("byte_array", byteArray);
                result.success(creationParams);
                return false;
            }
        }).submit();
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
