// In your_flutter_plugin/android/src/main/java/com/example/your_flutter_plugin/YourFlutterPlugin.java
package com.example.your_flutter_plugin

import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Bundle
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class YourFlutterPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var context: Context? = null
    private var mediaProjectionManager: MediaProjectionManager? = null
    private val mediaProjection: MediaProjection? = null
    @Override
    fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext()
        mediaProjectionManager =
            context.getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        val channel = MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL)
        channel.setMethodCallHandler(this)
    }

    @Override
    fun onDetachedFromEngine(@NonNull binding: FlutterPluginBinding?) {
        // Clean up resources if needed
    }

    @Override
    fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method.equals("takeScreenshot")) {
            startMediaProjection()
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    private fun startMediaProjection() {
        val projectionIntent: Intent = mediaProjectionManager.createScreenCaptureIntent()
        // You might want to start an activity to request the screen capture permission
        // Use startActivityForResult and handle the result in the activity
    }

    companion object {
        private const val CHANNEL = "Take_Screenshot"
    }
}