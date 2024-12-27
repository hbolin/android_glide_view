package com.dy.android_glide_view.widget;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class FlutterAndroidGlideView implements PlatformView {
    private final ImageView imageView;
    private final MethodChannel methodChannel;

    FlutterAndroidGlideView(Context context, BinaryMessenger messenger, int viewId, Map<String, Object> creationParams) {
        methodChannel = new MethodChannel(messenger, "com.dy.android_glide_view/FlutterAndroidGlideView_" + viewId);
        String imageUrl = (String) creationParams.get("image_url");
        int boxFit = (Integer) creationParams.get("box_fit");
        imageView = new ImageView(context);
        ImageView.ScaleType scaleType = getScaleType(boxFit);
        if (scaleType != null) {
            imageView.setScaleType(scaleType);
        }
        Glide.with(context).load(imageUrl).listener(new RequestListener<Drawable>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, @Nullable Object model, @NonNull Target<Drawable> target, boolean isFirstResource) {
                return false;
            }

            @Override
            public boolean onResourceReady(@NonNull Drawable resource, @NonNull Object model, Target<Drawable> target, @NonNull DataSource dataSource, boolean isFirstResource) {
                int width = resource.getIntrinsicWidth(); // 获取图像宽度
                int height = resource.getIntrinsicHeight(); // 获取图像高度
                Log.d("android_glide_view", "FlutterAndroidGlideView onResourceReady width:" + width + " height:" + height);
                Map<String, Object> creationParams = new HashMap<>();
                creationParams.put("image_width", width);
                creationParams.put("image_height", height);
                methodChannel.invokeMethod("resetSize", creationParams);
                return false;
            }
        }).into(imageView);
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
