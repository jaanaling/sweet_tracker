import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  // Каждый элемент - это карточка уведомления
  Widget _buildNotificationItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      // Здесь можно будет применить ваш дизайн.
      child: Row(
        children: [
          // Иконка или картинка уведомления (Placeholder)
          Container(
            width: 40,
            height: 40,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          // Текст уведомления
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Title'),
                Text('Text'),
              ],
            ),
          ),
          // Кнопка удаления уведомления
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simple Scaffold with Back button and title "Notifications"
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: 5, // Пример
        itemBuilder: (context, index) {
          return _buildNotificationItem(context);
        },
      ),
    );
  }
}
