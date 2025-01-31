import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendNotificationToTopic(
    String topic, String title, String body) async {
  const serverKey =
      'YOUR_SERVER_KEY_HERE'; // Replace with your Firebase server key.
  const url = 'https://fcm.googleapis.com/fcm/send';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final payload = {
    'to': '/topics/$topic', // Send to a topic
    'notification': {
      'title': title,
      'body': body,
      'sound': 'default',
    },
    'data': {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'status': 'done',
    },
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}
