package com.laoshi.shier;

import androidx.annotation.NonNull;

import com.laoshi.shier.utils.ServiceUtils;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        ServiceUtils.init(this,flutterEngine);
    }
}
