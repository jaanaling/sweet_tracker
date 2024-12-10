import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // Карточка истории
  Widget _buildHistoryItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      // Можно заменить на нужный дизайн потом.
      child: Row(
        children: [
          // Иконка/изображение
          Container(
            width: 40,
            height: 40,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          // Текст
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Title'),
                Text('Count'),
                Text('MM.DD.YYYY'),
              ],
            ),
          ),
          // Пример: кнопки подтверждения или удаления (по аналогии с макетом)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Экран истории использования
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildHistoryItem(context);
        },
      ),
    );
  }
}
