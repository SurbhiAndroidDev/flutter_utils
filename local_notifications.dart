import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;


final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> setup(RemoteMessage remoteMessage) async {
  const androidInitializationSetting = AndroidInitializationSettings('@mipmap/app_logo');
  const iosInitializationSetting = DarwinInitializationSettings();
  const initSettings = InitializationSettings(android: androidInitializationSetting, iOS: iosInitializationSetting);
  await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) {
        // handleData(remoteMessage, true);
      }
  );
}

void showLocalNotification(String title, String body) {
  const androidNotificationDetail = AndroidNotificationDetails(
      '0',
      'general',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true
  );
  const iosNotificatonDetail = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default'
  );
  const notificationDetails = NotificationDetails(
    iOS: iosNotificatonDetail,
    android: androidNotificationDetail,
  );
  _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
}


Future<void> showBigPictureNotification(String url, String title, String body) async {
  final ByteArrayAndroidBitmap largeIcon =
  ByteArrayAndroidBitmap(await _getByteArrayFromUrl(url));
  final ByteArrayAndroidBitmap bigPicture =
  ByteArrayAndroidBitmap(await _getByteArrayFromUrl(url));

  final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      bigPicture,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true);
  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    '00', '00',
    channelDescription: 'big icon channel description',
    styleInformation: bigPictureStyleInformation,
    importance: Importance.max, // Set the importance to max
    priority: Priority.high, // Set the priority to high
    fullScreenIntent: true, // Set this property to true for heads-up notification
  );
  final NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await _flutterLocalNotificationsPlugin.show(
      0, title, body, notificationDetails);
}

Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}