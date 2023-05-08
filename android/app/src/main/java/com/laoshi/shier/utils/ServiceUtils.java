package com.laoshi.shier.utils;

import android.content.Intent;

import com.laoshi.shier.MainActivity;
import com.laoshi.shier.service.ForegroundService;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ServiceUtils {
    private static final String TAG = "ServiceUtils";

    public static void init(MainActivity mainActivity, FlutterEngine flutterEngine) {

        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "shier/service");
        channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                switch (call.method) {
                    case "startService":
                        //设置用户信息
                        String title=call.argument("title");
                        String content=call.argument("content");
                        Intent intent1 =new  Intent(mainActivity.getApplicationContext(), ForegroundService.class);
                        intent1.putExtra("title", title);
                        intent1.putExtra("content", content);
                        mainActivity.getApplicationContext().startService(intent1);
                        result.notImplemented();
                        break;
                    case "stopService":
                        Intent intent2 =new  Intent(mainActivity.getApplicationContext(), ForegroundService.class);
                        mainActivity.getApplicationContext().stopService(intent2);
                        result.notImplemented();
                    default:
                        result.notImplemented();
                }
            }
        });
    }
}
