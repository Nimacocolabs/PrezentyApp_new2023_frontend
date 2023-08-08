package com.cocoalabs.event_app;

//import io.flutter.embedding.android.FlutterActivity;
//public class MainActivity extends FlutterActivity {
//}



import static android.app.Activity.RESULT_OK;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.camera2.CameraManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.net.Uri;
import android.provider.MediaStore;
import android.widget.Toast;

import java.net.URL;




import java.io.File;
import android.util.Log;
import android.widget.Toast;
import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;


public class MainActivity extends FlutterActivity {
    public static final String CHANNEL = "app_channel";
    Uri fileUri;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if(call.method == null) return;

                    if (call.method.equals("recordVideoWish")) {
                        recordVideoWish();
                    }

                });
    }

    public void recordVideoWish() {
        try {
            File externalStorage = getExternalFilesDir(null);

            File dir = new File(externalStorage.getAbsolutePath() + "/Camera");
            if (!dir.exists()) {
                dir.mkdirs();
            }

            File file = new File(dir.getPath() + File.separator + "video.mp4");
            file.delete();


            fileUri = FileProvider.getUriForFile(getApplicationContext(), getPackageName() + ".fileProvider", file);

            Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
            intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri);
            intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 0);

            if (intent.resolveActivity(getPackageManager()) != null) {
                startActivityForResult(intent, 1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK&& requestCode == 1) {
            if (fileUri != null) {
                Toast.makeText(getApplicationContext(), "Video recorded", Toast.LENGTH_SHORT).show();
            }
        }
    }
}