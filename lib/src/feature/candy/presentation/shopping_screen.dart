import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  // Карточка элемента в списке покупок
  Widget _buildShoppingItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      // Пример простого контейнера
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Иконка или изображение (плейсхолдер)
          Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 8),
          const Text('Title'),
          const Text('Subtitle or multiple lines'),
          // Редактировать иконка
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          // Удалить иконка
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Экран с gridView
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // два столбца
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildShoppingItem(context);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Кнопка экспорта в PDF
          FloatingActionButton(
            heroTag: 'pdf',
            onPressed: () {},
            child: const Icon(Icons.picture_as_pdf),
          ),
          const SizedBox(height: 16),
          // Кнопка отправки
          FloatingActionButton(
            heroTag: 'share',
            onPressed: () {},
            child: const Icon(Icons.share),
          ),
          const SizedBox(height: 16),
          // Кнопка добавления
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
