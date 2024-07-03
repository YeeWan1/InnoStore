import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Welcome New User',
      'message': 'We are excited to have you on board!'
    },
    {
      'title': 'New User Voucher',
      'message': 'You have received a voucher. Check it out in your account.'
    },
    {
      'title': 'Buy 1 Get 1 Free',
      'message': 'Special offer! Buy 1 get 1 free on select items.'
    },
    {
      'title': 'Discounts on Products',
      'message': 'Check out the latest discounts on your favorite products.'
    },
    {
      'title': 'Promotion Alert',
      'message': 'Don’t miss out on our latest promotion!'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(notifications[index]['title']!),
              subtitle: Text(notifications[index]['message']!),
              leading: Icon(Icons.notifications, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
