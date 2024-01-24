// import 'package:flutter/material.dart';
// class MyScreenRecorderApp extends StatefulWidget {
//   @override
//   _MyScreenRecorderAppState createState() => _MyScreenRecorderAppState();
// }
//
// class _MyScreenRecorderAppState extends State<MyScreenRecorderApp> {
//   @override
//   void initState() {
//     super.initState();
//
//     // Register shortcut
//     FlutterShortcuts.registerShortcut(
//       action: "startRecording",
//       callback: () {
//         // Handle shortcut to start recording
//         startRecording();
//       },
//     );
//
//     FlutterShortcuts.registerShortcut(
//       action: "stopRecording",
//       callback: () {
//         // Handle shortcut to stop recording
//         stopRecording();
//       },
//     );
//   }
//
//   void startRecording() async {
//     // Your logic to start recording
//     await ScreenRecorder.startRecordScreen;
//   }
//
//   void stopRecording() async {
//     // Your logic to stop recording
//     await ScreenRecorder.stopRecordScreen;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Screen Recorder App'),
//       ),
//       body: Center(
//         child: Text('Your screen recorder UI goes here.'),
//       ),
//     );
//   }
// }