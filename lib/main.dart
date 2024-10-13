import 'package:bday/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'widgets/bday_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.initDB();

  worker();

  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => StorageService(),
    child: const BDayApp(),
  ));
}

void worker() {
  Workmanager().initialize(callbackDispatcher);
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",
    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: const Duration(minutes: 15),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();

    // initialise settings for both Android and iOS device.
    const settings = InitializationSettings(android: android, iOS: iOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high);
  const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flip.show(
      0,
      'GeeksforGeeks',
      'Your are one step away to connect with GeeksforGeeks',
      platformChannelSpecifics,
      payload: 'Default_Sound');
}
