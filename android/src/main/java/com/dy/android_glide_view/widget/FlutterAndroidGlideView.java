package com.dy.android_glide_view.widget;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;

import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class FlutterAndroidGlideView implements PlatformView {
    private final ImageView imageView;

    FlutterAndroidGlideView(Context context, BinaryMessenger messenger, int viewId, Map<String, Object> creationParams) {
        for (Map.Entry<String, Object> entry : creationParams.entrySet()) {
            Log.d("FlutterAndroidGlideView", "FlutterAndroidGlideView:" + entry.getKey() + " : " + entry.getValue());
        }
        String imageUrl = (String) creationParams.get("image_url");
        imageView = new ImageView(context);
        ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        imageView.setLayoutParams(layoutParams);
        imageView.setAdjustViewBounds(true);
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        Glide.with(context).load(imageUrl).into(imageView);
    }

    @Nullable
    @Override
    public View getView() {
        return imageView;
    }

    @Override
    public void dispose() {
        // nothing
    }
}
