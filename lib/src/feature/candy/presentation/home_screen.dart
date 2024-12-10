import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sweet_planner/routes/go_router_config.dart';
import 'package:sweet_planner/routes/route_value.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:sweet_planner/src/feature/candy/model/candy.dart';
import 'package:sweet_planner/src/feature/candy/model/storage_location.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_category.dart';

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
  final TextEditingController _searchController = TextEditingController();
  final Map<SweetCategory, List<String>> storageFilter = {};

  /// Построение контента для списка конфет
  Widget _buildContent(List<Candy> candies) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Например, 4 столбца
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: candies.length,
      itemBuilder: (context, index) {
        final candy = candies[index];
        return Container(
          color: Colors.grey.shade300,
          child: _showFullDetails
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(candy.name),
                    Text('Some details'),
                    Text('More info'),
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  /// Отображение всплывающего меню настроек
  void _showSettingsPopup() async {
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
        storageFilter.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandyBloc, CandyState>(
      builder: (context, state) {
        if (state is CandyLoaded) {
          // Объединенная фильтрация по имени и месту хранения
          final List<Candy> filteredCandys = state.candies.where((candy) {
            // Фильтрация по имени конфеты
            bool matchesName = candy.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

            // Фильтрация по месту хранения (местоположению) для категории
            bool matchesLocation = false;
            if (storageFilter.containsKey(candy.category)) {
              final categoryFilter = storageFilter[candy.category]!;
              if (categoryFilter.isEmpty) {
                matchesLocation =
                    true; // Если фильтр пустой, пропускаем местоположение
              } else {
                // Проверка, если местоположение конфеты входит в фильтр
                matchesLocation =
                    categoryFilter.contains(candy.location.name) ||
                        categoryFilter.contains(candy.location.name);
              }
            } else {
              matchesLocation =
                  true; // Если нет фильтра для категории, пропускаем местоположение
            }

            // Возвращаем конфету, если она проходит оба фильтра
            return matchesName && matchesLocation;
          }).toList();

          // Группируем отфильтрованные конфеты по категории и месту хранения
          final filtredGropedCandys =
              <SweetCategory, Map<StorageLocation, List<Candy>>>{};
          for (final candy in filteredCandys) {
            filtredGropedCandys.putIfAbsent(candy.category, () => {});
            filtredGropedCandys[candy.category]
                ?.putIfAbsent(candy.location, () => [])
                .add(candy);
          }
          final groupedCandys = <SweetCategory, List<Candy>>{};
          for (final candy in filteredCandys) {
            groupedCandys.putIfAbsent(candy.category, () => []).add(candy);
          }
          // Вывод отладочной информации
          print('Filtered candies: $filteredCandys');
          print('Grouped candies: $groupedCandys');
          print('Filtered grouped candies: $filtredGropedCandys');
          print('Storage filter: $storageFilter');

          return Scaffold(
            appBar: AppBar(
              title: const Text('Home page'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    context.push(
                      "${RouteValue.home.path}/${RouteValue.notification.path}",
                    );
                  },
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
                    controller: _searchController,
                    onChanged: (value) {
                      setState(
                          () {}); // Обновляем состояние при изменении текста поиска
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      hintText: 'Search...',
                    ),
                  ),
                ),
                // Отображение списка конфет в зависимости от настроек группировки
                if (_groupByCategory && _groupByLocation)
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: filtredGropedCandys.length,
                      itemBuilder: (context, index) {
                        final category =
                            filtredGropedCandys.keys.elementAt(index);
                        final storageMap =
                            filtredGropedCandys.values.elementAt(index);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Заголовок категории
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                            const Gap(16),
                            // Виджеты для выбора места хранения
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...storageMap.keys
                                      .map((storageLocation) => storageWidget(
                                          storageLocation.name,
                                          category,
                                          storageLocation.name))
                                      .toList(),
                                ],
                              ),
                            ),
                            // Отображение конфет
                            _buildContent(
                                storageMap.values.expand((x) => x).toList()),
                          ],
                        );
                      },
                    ),
                  )
                else if (_groupByCategory)
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: filtredGropedCandys.length,
                      itemBuilder: (context, index) {
                        final category =
                            filtredGropedCandys.keys.elementAt(index);
                        final storageMap =
                            filtredGropedCandys.values.elementAt(index);

                        // Получаем все конфеты для данной категории
                        final candies =
                            storageMap.values.expand((x) => x).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Заголовок категории
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                            const Gap(16),
                            // Отображение конфет
                            _buildContent(candies),
                          ],
                        );
                      },
                    ),
                  )
                else if (_groupByLocation)
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: filtredGropedCandys.length,
                      itemBuilder: (context, index) {
                        final category =
                            filtredGropedCandys.keys.elementAt(index);
                        final storageMap =
                            filtredGropedCandys.values.elementAt(index);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Заголовок категории
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                            const Gap(16),
                            // Виджеты для выбора места хранения
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...storageMap.keys
                                      .map((storageLocation) => storageWidget(
                                          storageLocation.name,
                                          category,
                                          storageLocation.name))
                                      .toList(),
                                ],
                              ),
                            ),
                            // Отображение конфет
                            _buildContent(
                                storageMap.values.expand((x) => x).toList()),
                          ],
                        );
                      },
                    ),
                  )
                else
                  // Если нет группировки, отображаем все конфеты
                  Expanded(
                    child: _buildContent(filteredCandys),
                  ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.push("${RouteValue.home.path}/${RouteValue.add.path}");
              },
              child: const Icon(Icons.add),
            ),
          );
        }
        // Если состояние не загружено, показываем индикатор загрузки
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// Виджет для выбора места хранения
  TextButton storageWidget(String storage, SweetCategory category, String id) {
    return TextButton(
      onPressed: () {
        setState(() {
          if (storageFilter[category] == null) {
            storageFilter[category] = [id];
          } else if (storageFilter[category]!.contains(id)) {
            storageFilter[category]!.remove(id);
          } else {
            storageFilter[category]!.add(id);
          }
        });
      },
      child: Text(storage),
    );
  }
}
