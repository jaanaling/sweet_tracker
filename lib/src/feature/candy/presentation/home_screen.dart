import 'package:flutter/material.dart';

enum HomeDisplayMode {
  fullDetails,
  groupByCategory,
  groupByLocation,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _groupByCategory = true;
  bool _groupByLocation = true;
  bool _showFullDetails = false;

  // В зависимости от состояния меняем отображение:
  // Например, если выключены все, показываем простой GridView,
  // если включены — группируем или показываем разные заголовки.
  Widget _buildContent() {
    // Для примера: если groupByCategory = true, показываем текстовый заголовок и элементы под ним
    // Тут можно использовать ListView или GridView с секциями.
    // Упрощенно: если groupByCategory и groupByLocation - просто показываем GridView.
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Например, 4 столбца
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey.shade300,
          child: _showFullDetails
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Title'),
                    Text('Some details'),
                    Text('More info'),
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  void _showSettingsPopup() async {
    // Показываем popup
    final result = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        CheckedPopupMenuItem(
          value: 'location',
          checked: _groupByLocation,
          child: const Text('Storage Location'),
        ),
        CheckedPopupMenuItem(
          value: 'category',
          checked: _groupByCategory,
          child: const Text('Category'),
        ),
        CheckedPopupMenuItem(
          value: 'fullDetails',
          checked: _showFullDetails,
          child: const Text('Full details'),
        ),
      ],
    );

    if (result != null) {
      setState(() {
        if (result == 'location') {
          _groupByLocation = !_groupByLocation;
        } else if (result == 'category') {
          _groupByCategory = !_groupByCategory;
        } else if (result == 'fullDetails') {
          _showFullDetails = !_showFullDetails;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // HomeScreen с поиском, иконкой настроек и уведомлений.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsPopup,
          ),
        ],
      ),
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                hintText: 'Search...',
              ),
            ),
          ),
          // Пример заголовка группы (For kids / For tea и т.д.)
          Row(
            children: [
              // Эти кнопки можно переключать для фильтрации
              TextButton(onPressed: () {}, child: const Text('in fridge')),
              TextButton(onPressed: () {}, child: const Text('in shelf')),
            ],
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
