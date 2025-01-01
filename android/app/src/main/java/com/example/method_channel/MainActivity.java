package com.example.method_channel;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull;
import android.content.Intent;
import android.Manifest;
import android.content.pm.PackageManager;
import androidx.core.content.ContextCompat;
import androidx.core.app.ActivityCompat;

public class MainActivity extends FlutterActivity {
     private static final String CHANNEL = "com.example.native_bridge";
     private static final int PERMISSION_REQUEST_CODE = 1;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        // ActivityCompat.requestPermissions(this, 
        // new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.FOREGROUND_SERVICE_LOCATION,Manifest.permission.POST_NOTIFICATIONS}, 
        // PERMISSION_REQUEST_CODE);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("startPlayer")) {
                                 startPlayer();
                                 result.success("Player started");
                                // if (message != null) {
                                //     result.success(message);
                                // } else {
                                //     result.error("UNAVAILABLE", "Message not available.", null);
                                // }
                            }
                            else if (call.method.equals("stopPlayer")) {
                                 stopPlayer();
                                 result.success("Player stopped");}
                                // if (message != null) {
                                //     result.success(message);
                                // } else {
                                //     result.error("UNAVAILABLE", "Message not available.", null);
                                // }
                             else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private void startPlayer() {
        //  Intent serviceIntent = new Intent(this, CustomService.class);
         Intent serviceIntent = new Intent(this, LocationService.class);
            startService(serviceIntent);
        // return "Hello from Native Android Code!";
    }
    private void stopPlayer() {
        //  Intent serviceIntent = new Intent(this, CustomService.class);
         Intent serviceIntent = new Intent(this, LocationService.class);
            stopService(serviceIntent);
        // return "Hello from Native Android Code!";
    }
}
