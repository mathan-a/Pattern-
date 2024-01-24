// In your_flutter_plugin/lib/your_flutter_plugin.dart
import 'package:flutter/services.dart';

class YourFlutterPlugin {
  static const MethodChannel _channel =
  MethodChannel('Take_Screenshot');

  static Future<void> takeScreenshot() async {
    try {
      await _channel.invokeMethod('takeScreenshot');
      // Handle success
    } catch (e) {
      // Handle errors
    }
  }
}
