import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled/HomePage.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:android_window/android_window.dart';
import 'package:floating_overlay/floating_overlay.dart';
import 'package:dash_bubble/dash_bubble.dart';
import 'package:screenshot/screenshot.dart';
import 'package:native_screenshot_ext/native_screenshot_ext.dart';
// import 'package:native_screenshot/native_screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

import 'flutter_plugin.dart';

const MethodChannel _channel = MethodChannel('record_channel');

Future<void> startRecording() async {
  await _channel.invokeMethod('startRecording');
}

Future<void> stopRecording() async {
  await _channel.invokeMethod('stopRecording');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  if(!await DashBubble.instance.hasOverlayPermission()){
    DashBubble.instance.requestOverlayPermission();
  }
  if(!await FlutterOverlayWindow.isPermissionGranted()){
   FlutterOverlayWindow.requestPermission();}
  runApp(const MyApp());


}
// @pragma("vm:entry-point")

// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MaterialApp(home: Overrelay()));
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  FloatingButtonService(),
    );
  }
}
class FloatingButtonService extends StatefulWidget {

  @override
  _FloatingButtonServiceState createState() => _FloatingButtonServiceState();
}

class _FloatingButtonServiceState extends State<FloatingButtonService> {
  late ScreenshotController screenshotController;
  Uint8List? image;
  File? imgfile;
//   OverlayEntry? entry;
//   Offset offset = Offset(20, 40);

  @override
  void initState(){
    super.initState();
    Permission.storage.request();
    screenshotController = ScreenshotController();
    startBubble(
        bubbleOptions: BubbleOptions(
          bubbleIcon: "Images/img.png",
          bubbleSize: 40,
          enableAnimateToEdge: true,
          enableBottomShadow: true,
          enableClose: false,
          distanceToClose: 90,
          keepAliveWhenAppExit: false,
        ),
      onTap: () =>  checkAndRequestPermissions(),


    );

    // WidgetsBinding.instance!.addPostFrameCallback((_)=>showoverlay());
    // await FlutterOverlayWindow.showOverlay(height: 500,width: 500);
  }
  Future<void> checkAndRequestPermissions() async {
    final permissionStatus = await Permission.photos.status;
    if (permissionStatus.isDenied) {
      final status = await Permission.photos.request();

      if (await status.isDenied) {
        // Permission is still denied after the request
        print("1");
        await openAppSettings();
      } else {
        // Permission granted, proceed with the desired action
        YourFlutterPlugin.takeScreenshot();
      }
    } else if (permissionStatus.isPermanentlyDenied) {

      print("2");
      await openAppSettings();
    } else {
      YourFlutterPlugin.takeScreenshot();
    }
  }
  // Future<void> takeScreenshot() async {
  //   try {
  //
  //     String? path = await NativeScreenshot.takeScreenshot();
  //     debugPrint('Screenshot taken, path: $path');
  //
  //     if (path == null || path.isEmpty) {
  //       throw Exception('Error taking the screenshot :(');
  //     }
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('The screenshot has been saved to: $path'),
  //       ),
  //     );
  //     setState(() {
  //       imgfile = File(path);
  //     });
  //   } catch (e) {
  //     debugPrint('Error taking screenshot: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error taking the screenshot :('),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  //
  // }
  Future<void> startBubble(
      {required BubbleOptions bubbleOptions, required void Function() onTap}) async {
    final hasStarted = await DashBubble.instance.startBubble(
        bubbleOptions: bubbleOptions,
        onTap: onTap
    );
    if (hasStarted == true)
      print("Bubble started");
    else
      print("Not Started");
  }


 @override
  void dispose() {

    super.dispose();
    // hiderelay();
  }
  void hiderelay(){


  }
  // void showoverlay(){
  //   entry = OverlayEntry(builder: (context)=>Positioned(
  //     left: offset.dx,
  //     right: offset.dy,
  //     child: GestureDetector(
  //       onPanUpdate: (det){
  //
  //         offset+=det.delta;
  //         entry!.markNeedsBuild();
  //       },
  //       child: ElevatedButton.icon(
  //         icon: Icon(Icons.stop_circle_rounded),
  //         label: Text('Take Screenshot'),
  //         onPressed: (){},
  //       ),
  //     ),
  //   ));
  //   final overlay = Overlay.of(context)!;
  //   overlay.insert(entry!);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text("Dark Pattern"),
              if(imgfile!=null)
                Image.file(imgfile!)

            ],
          ),
        ),
      ),
    );
  }
}

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({super.key});

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.videocam),
      ),
    );
  }
}
// class Overrelay extends StatefulWidget {
//   const Overrelay({super.key});
//
//   @override
//   State<Overrelay> createState() => _OverrelayState();
// }
//
//
// class _OverrelayState extends State<Overrelay> {
//   Offset offset = Offset(20, 40);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Positioned(
//           left: offset.dx,
//           right: offset.dy,
//           child: GestureDetector(
//             onPanUpdate: (det){
//
//               setState(() {
//                 offset+=det.delta;
//               });
//             },
//             child: ElevatedButton.icon(
//               icon: Icon(Icons.stop_circle_rounded),
//               label: Text('Take Screenshot'),
//               onPressed: (){},
//             ),
//           ),
//         ),
//       )
//     );
//   }
// }
