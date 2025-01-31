import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings =
      await messaging.requestPermission(alert: true, badge: true, sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("got the permission ");
  } else {
    print("didnot got he permission ");
  }
}
