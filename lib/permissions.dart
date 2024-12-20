import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid && (await Permission.scheduleExactAlarm.isDenied)) {
    final status = await Permission.scheduleExactAlarm.request();
    if (!status.isGranted) {
      throw Exception('Exact alarm permission not granted!');
    }
  }
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
