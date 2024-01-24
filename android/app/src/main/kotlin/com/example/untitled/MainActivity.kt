import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Bundle
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "your_channel_name"
    private val REQUEST_MEDIA_PROJECTION = 1

    private var mediaProjectionManager: MediaProjectionManager? = null
    private var mediaProjection: MediaProjection? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger ?: return, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "takeScreenshot") {
                    takeScreenshot()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun takeScreenshot() {
        if (mediaProjectionManager == null) {
            mediaProjectionManager =
                getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        }

        if (mediaProjection == null) {
            startActivityForResult(
                mediaProjectionManager?.createScreenCaptureIntent(),
                REQUEST_MEDIA_PROJECTION
            )
        } else {
            captureScreen()
        }
    }

    private fun captureScreen() {
        val metrics = resources.displayMetrics
        val width = metrics.widthPixels
        val height = metrics.heightPixels
        val density = metrics.densityDpi

        val surface = mediaProjection?.createVirtualDisplay(
            "Screenshot",
            width, height, density,
            0, null, null, null
        )?.surface

        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)

        surface?.let {
            canvas.drawBitmap(bitmap, 0f, 0f, null)
        }

        try {
            val screenshotFile = getExternalFilesDir(null)?.let {
                File(it, "screenshot.png")
            }
            FileOutputStream(screenshotFile).use { fos ->
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos)
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_MEDIA_PROJECTION && resultCode == RESULT_OK) {
            mediaProjection = mediaProjectionManager?.getMediaProjection(resultCode, data)
            captureScreen()
        }
    }
}
