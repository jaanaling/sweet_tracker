import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  // Каждый элемент - это карточка уведомления
  Widget _buildNotificationItem(
      BuildContext context, SweetNotification notification) {
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
              children: [
                Text(notification.message),
                Text('Text'),
              ],
            ),
          ),
          // Кнопка удаления уведомления
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<CandyBloc>().add(DeleteNotification(notification));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simple Scaffold with Back button and title "Notifications"
    return BlocBuilder<CandyBloc, CandyState>(
      builder: (context, state) {
        if (state is CandyError) {
          return const Center(child: Text('Error'));
        }
        if (state is CandyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CandyLoaded) {
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
              itemCount: state.notifications.length, // Пример
              itemBuilder: (context, index) {
                return _buildNotificationItem(context, state.notifications[index]
);
              },
            ),
          );
        }
        return const Center(child: Text('Success'));
      },
    );
  }
}
