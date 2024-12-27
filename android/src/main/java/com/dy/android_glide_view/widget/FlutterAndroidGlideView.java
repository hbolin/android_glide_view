package com.dy.android_glide_view.widget;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;

import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

public class FlutterAndroidGlideView implements PlatformView {
    private final ImageView imageView;

    FlutterAndroidGlideView(Context context, int viewId, Map<String, Object> creationParams) {
        String imageUrl = (String) creationParams.get("image_url");
        int boxFit = (Integer) creationParams.get("box_fit");
        imageView = new ImageView(context);
        ImageView.ScaleType scaleType = getScaleType(boxFit);
        if (scaleType != null) {
            imageView.setScaleType(scaleType);
        }
        Glide.with(context).load(imageUrl).into(imageView);
    }

    private static ImageView.ScaleType getScaleType(int boxFit) {
        ImageView.ScaleType scaleType = null;
        if (boxFit == 1) {
            scaleType = ImageView.ScaleType.FIT_XY;
        } else if (boxFit == 2) {
            scaleType = ImageView.ScaleType.FIT_CENTER;
        } else if (boxFit == 3) {
            scaleType = ImageView.ScaleType.CENTER_CROP;
        } else if (boxFit == 4) {
            //
        } else if (boxFit == 5) {
            //
        } else if (boxFit == 6) {
            //
        } else if (boxFit == 7) {
            //
        }
        return scaleType;
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
